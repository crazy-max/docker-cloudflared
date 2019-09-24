# syntax=docker/dockerfile:experimental
FROM --platform=amd64 golang:alpine as builder

ENV CLOUDFLARED_VERSION="2019.9.0"

RUN apk --update --no-cache add \
    bash \
    build-base \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared /go/src/github.com/cloudflare/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared
COPY gobuild.sh ./
RUN bash gobuild.sh ${TARGETPLATFORM}
RUN ./cloudflared --version

ARG TARGETPLATFORM
FROM --platform=$TARGETPLATFORM alpine:latest

LABEL maintainer="CrazyMax" \
  org.label-schema.name="cloudflared" \
  org.label-schema.description="Cloudflared proxy-dns" \
  org.label-schema.url="https://github.com/crazy-max/docker-cloudflared" \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-cloudflared" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

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

USER cloudflared

EXPOSE 5053/udp
EXPOSE 49312/tcp

ENTRYPOINT [ "/usr/local/bin/cloudflared" ]
CMD [ "proxy-dns" ]
