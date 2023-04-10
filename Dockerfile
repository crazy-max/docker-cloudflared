# syntax=docker/dockerfile:1

ARG CLOUDFLARED_VERSION=2023.3.1
ARG ALPINE_VERSION=3.17
ARG GO_VERSION=1.19
ARG XX_VERSION=1.1.2

FROM --platform=${BUILDPLATFORM:-linux/amd64} tonistiigi/xx:${XX_VERSION} AS xx
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:${GO_VERSION}-alpine AS builder
RUN apk --update --no-cache add file git
COPY --from=xx / /
WORKDIR /src
ARG CLOUDFLARED_VERSION
RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared .
ARG TARGETPLATFORM
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN xx-go build -v -mod=vendor -trimpath -o /bin/cloudflared \
    -ldflags="-w -s -X 'main.Version=${CLOUDFLARED_VERSION}' -X 'main.BuildTime=${BUILD_DATE}'" \
    ./cmd/cloudflared \
  && xx-verify --static /bin/cloudflared

FROM alpine:${ALPINE_VERSION}

ENV TZ="UTC" \
  TUNNEL_METRICS="0.0.0.0:49312" \
  TUNNEL_DNS_ADDRESS="0.0.0.0" \
  TUNNEL_DNS_PORT="5053" \
  TUNNEL_DNS_UPSTREAM="https://1.1.1.1/dns-query,https://1.0.0.1/dns-query"

RUN apk --update --no-cache add bind-tools ca-certificates openssl shadow tzdata \
  && addgroup -g 1000 cloudflared \
  && adduser -u 1000 -G cloudflared -s /sbin/nologin -D cloudflared

COPY --from=builder /bin/cloudflared /usr/local/bin/cloudflared
RUN cloudflared --no-autoupdate --version

USER cloudflared

EXPOSE 5053/udp
EXPOSE 49312/tcp

ENTRYPOINT [ "/usr/local/bin/cloudflared", "--no-autoupdate" ]
CMD [ "proxy-dns" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD dig +short @127.0.0.1 -p $TUNNEL_DNS_PORT cloudflare.com A || exit 1
