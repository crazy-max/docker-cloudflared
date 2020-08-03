FROM --platform=${BUILDPLATFORM:-linux/amd64} tonistiigi/xx:golang AS xgo
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.13-alpine as builder

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

COPY --from=xgo / /

RUN apk --update --no-cache add \
    bash \
    build-base \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

ENV CLOUDFLARED_VERSION="2020.8.0"
RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared /go/src/github.com/cloudflare/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN go build -v -mod vendor -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}' -X 'main.BuildTime=${BUILD_DATE}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="CrazyMax" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/crazy-max/docker-cloudflared" \
  org.opencontainers.image.source="https://github.com/crazy-max/docker-cloudflared" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="CrazyMax" \
  org.opencontainers.image.title="Cloudflared" \
  org.opencontainers.image.description="Cloudflared proxy-dns" \
  org.opencontainers.image.licenses="MIT"

ENV TZ="UTC" \
  TUNNEL_METRICS="0.0.0.0:49312" \
  TUNNEL_DNS_ADDRESS="0.0.0.0" \
  TUNNEL_DNS_PORT="5053" \
  TUNNEL_DNS_UPSTREAM="https://1.1.1.1/dns-query,https://1.0.0.1/dns-query"

RUN apk --update --no-cache add \
    bind-tools \
    ca-certificates \
    libressl \
    shadow \
    tzdata \
  && addgroup -g 1000 cloudflared \
  && adduser -u 1000 -G cloudflared -s /sbin/nologin -D cloudflared \
  && rm -rf /tmp/* /var/cache/apk/*

COPY --from=builder /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/cloudflared
RUN cloudflared --version

USER cloudflared

EXPOSE 5053/udp
EXPOSE 49312/tcp

ENTRYPOINT [ "/usr/local/bin/cloudflared" ]
CMD [ "proxy-dns" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD dig +short @127.0.0.1 -p 5053 cloudflare.com A || exit 1
