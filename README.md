<p align="center"><a href="https://github.com/crazy-max/docker-cloudflared" target="_blank"><img height="128" src=".res/docker-cloudflared.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/cloudflared/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-cloudflared?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-cloudflared/actions?workflow=build"><img src="https://img.shields.io/github/workflow/status/crazy-max/docker-cloudflared/build?label=build&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/stars/crazymax/cloudflared.svg?style=flat-square&logo=docker" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/pulls/crazymax/cloudflared.svg?style=flat-square&logo=docker" alt="Docker Pulls"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-cloudflared"><img src="https://img.shields.io/codacy/grade/93db381dca8b441cb69b45b75f5e10ed.svg?style=flat-square" alt="Code Quality"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Cloudflared](https://github.com/cloudflare/cloudflared) proxy-dns Docker image based on Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Docker

### Multi-platform image

Following platforms for this image are available:

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

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following [docker compose template](examples/compose/docker-compose.yml), then run the container:

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

## Notes

### Use with Pi-hole

[Pi-hole](https://pi-hole.net/) currently [provides documentation](https://docs.pi-hole.net/guides/dns-over-https/) to manually set up DNS-Over-HTTPS with Cloudflared.

With Docker and this image, it's quite easy to use it with [Pi-hole](https://pi-hole.net/). Take a look at this simple [docker compose template](examples/pihole/docker-compose.yml) and you're ready to go.

## Upgrade

To upgrade, pull the newer image and launch the container :

```bash
docker-compose pull
docker-compose up -d
```

## How can I help ?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon: You can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
