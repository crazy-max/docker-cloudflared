ARG CLOUDFLARED_VERSION=2021.8.2

FROM --platform=${BUILDPLATFORM:-linux/amd64} tonistiigi/xx:golang AS xgo
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.16-alpine3.14 AS builder

COPY --from=xgo / /

RUN apk --update --no-cache add \
    bash \
    build-base \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

ARG CLOUDFLARED_VERSION
RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared /go/src/github.com/cloudflare/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared

ARG TARGETPLATFORM
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go build -v -mod vendor -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}' -X 'main.BuildTime=${BUILD_DATE}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM alpine:3.14

ENV TZ="UTC" \
  TUNNEL_METRICS="0.0.0.0:49312" \
  TUNNEL_DNS_ADDRESS="0.0.0.0" \
  TUNNEL_DNS_PORT="5053" \
  TUNNEL_DNS_UPSTREAM="https://1.1.1.1/dns-query,https://1.0.0.1/dns-query"

RUN apk --update --no-cache add \
    bind-tools \
    ca-certificates \
    openssl \
    shadow \
    tzdata \
  && addgroup -g 1000 cloudflared \
  && adduser -u 1000 -G cloudflared -s /sbin/nologin -D cloudflared \
  && rm -rf /tmp/* /var/cache/apk/*

COPY --from=builder /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/cloudflared
RUN cloudflared --no-autoupdate --version

USER cloudflared

EXPOSE 5053/udp
EXPOSE 49312/tcp

ENTRYPOINT [ "/usr/local/bin/cloudflared", "--no-autoupdate" ]
CMD [ "proxy-dns" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD dig +short @127.0.0.1 -p $TUNNEL_DNS_PORT cloudflare.com A || exit 1
