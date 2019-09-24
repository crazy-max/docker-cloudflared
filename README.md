<p align="center"><a href="https://github.com/crazy-max/docker-cloudflared" target="_blank"><img height="128"src=".res/docker-cloudflared.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/cloudflared/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-cloudflared?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/badge/dynamic/json.svg?label=version&query=$.results[1].name&url=https://hub.docker.com/v2/repositories/crazymax/cloudflared/tags&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-cloudflared/actions"><img src="https://github.com/crazy-max/docker-cloudflared/workflows/build/badge.svg" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/stars/crazymax/cloudflared.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/pulls/crazymax/cloudflared.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-cloudflared"><img src="https://img.shields.io/codacy/grade/93db381dca8b441cb69b45b75f5e10ed.svg?style=flat-square" alt="Code Quality"></a>
  <br /><a href="https://www.patreon.com/crazymax"><img src="https://img.shields.io/badge/donate-patreon-f96854.svg?logo=patreon&style=flat-square" alt="Support me on Patreon"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Cloudflared](https://github.com/cloudflare/cloudflared) proxy-dns Docker image based on Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Features

* Alpine Linux 3.10
* Multi-platform Docker image

## Docker

### Multi-platform

Following multi-platform image are available:

```
$ docker run --rm mplatform/mquery crazymax/cloudflared:latest
Image: crazymax/cloudflared:latest
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64
   - linux/386
   - linux/ppc64le
   - linux/s390x
```

### Environment variables

* `TZ` : The timezone assigned to the container (default `UTC`)
* `TUNNEL_DNS_UPSTREAM` : Upstream endpoint URL, you can specify multiple endpoints for redundancy. (default `https://1.1.1.1/dns-query,https://1.0.0.1/dns-query`)

### Ports

* `5053/udp` : Listen port for the DNS over HTTPS proxy server
* `49312/tcp` : Listen port for metrics reporting

## Use this image

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following [docker compose template](examples/compose/docker-compose.yml), then run the container :

```bash
docker-compose up -d
docker-compose logs -f
```

### Command line

You can also use the following minimal command :

```bash
docker run -d --name cloudflared \
  -p 5053:5053/udp \
  -p 49312:49312 \
  crazymax/cloudflared:latest
```

## Upgrade

To upgrade, pull the newer image and launch the container :

```bash
docker-compose pull
docker-compose up -d
```

## How can I help ?

All kinds of contributions are welcome :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
But we're not gonna lie to each other, I'd rather you buy me a beer or two :beers:!

[![Support me on Patreon](.res/patreon.png)](https://www.patreon.com/crazymax) 
[![Paypal Donate](.res/paypal.png)](https://www.paypal.me/crazyws)

## License

MIT. See `LICENSE` for more details.
