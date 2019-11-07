# syntax=docker/dockerfile:experimental
FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:alpine as builder

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

ENV CLOUDFLARED_VERSION="2019.11.0"

RUN apk --update --no-cache add \
    bash \
    build-base \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared /go/src/github.com/cloudflare/cloudflared
WORKDIR /go/src/github.com/cloudflare/cloudflared
RUN make cloudflared

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="CrazyMax" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="cloudflared" \
  org.label-schema.description="Cloudflared proxy-dns" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-cloudflared" \
  org.label-schema.vcs-ref=$VCS_REF \
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
RUN cloudflared --version

USER cloudflared

EXPOSE 5053/udp
EXPOSE 49312/tcp

ENTRYPOINT [ "/usr/local/bin/cloudflared" ]
CMD [ "proxy-dns" ]

HEALTHCHECK --interval=30s --timeout=20s --start-period=10s \
  CMD dig +short @127.0.0.1 -p 5053 cloudflare.com A || exit 1
