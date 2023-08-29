<p align="center"><a href="https://github.com/crazy-max/docker-cloudflared" target="_blank"><img height="128" src=".github/docker-cloudflared.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/cloudflared/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-cloudflared?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-cloudflared/actions?workflow=build"><img src="https://img.shields.io/github/actions/workflow/status/crazy-max/docker-cloudflared/build.yml?branch=master&label=build&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/stars/crazymax/cloudflared.svg?style=flat-square&logo=docker" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/cloudflared/"><img src="https://img.shields.io/docker/pulls/crazymax/cloudflared.svg?style=flat-square&logo=docker" alt="Docker Pulls"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

Docker image for [Cloudflared](https://github.com/cloudflare/cloudflared), a
proxy-dns service.

> **Note**
> 
> Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun)
> project!

___

* [Build locally](#build-locally)
* [Image](#image)
* [Environment variables](#environment-variables)
* [Ports](#ports)
* [Usage](#usage)
  * [Docker Compose](#docker-compose)
  * [Command line](#command-line)
* [Upgrade](#upgrade)
* [Notes](#notes)
  * [Performance issues](#performance-issues)
  * [Use with Pi-hole](#use-with-pi-hole)
* [Contributing](#contributing)
* [License](#license)

## Build locally

```shell
git clone https://github.com/crazy-max/docker-cloudflared.git
cd docker-cloudflared

# Build image and output to docker (default)
docker buildx bake

# Build multi-platform image
docker buildx bake image-all
```

## Image

| Registry                                                                                               | Image                           |
|--------------------------------------------------------------------------------------------------------|---------------------------------|
| [Docker Hub](https://hub.docker.com/r/crazymax/cloudflared/)                                           | `crazymax/cloudflared`          |
| [GitHub Container Registry](https://github.com/users/crazy-max/packages/container/package/cloudflared) | `ghcr.io/crazy-max/cloudflared` |

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
```

## Environment variables

* `TZ`: The timezone assigned to the container (default `UTC`)
* `TUNNEL_DNS_UPSTREAM`: Upstream endpoint URL, you can specify multiple endpoints for redundancy. (default `https://1.1.1.1/dns-query,https://1.0.0.1/dns-query`)
* `TUNNEL_DNS_PORT`: DNS listening port (default `5053`)
* `TUNNEL_DNS_ADDRESS`: DNS listening IP (default `0.0.0.0` "all interfaces")
* `TUNNEL_METRICS`: Prometheus metrics host and port. (default `0.0.0.0:49312`)

## Ports

* `5053/udp`: Listen port for the DNS over HTTPS proxy server
* `49312/tcp`: Listen port for metrics reporting

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. You can use the
following [docker compose template](examples/compose/compose.yml), then run
the container:

```bash
docker compose up -d
docker compose logs -f
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

### Performance issues

For a DNS server with lots of short-lived connections, you may wish to consider
adding `--net=host` to the run command or `network_mode: "host"` in your compose
file for performance reasons (see [#22](https://github.com/crazy-max/docker-cloudflared/issues/22)).
However, it is not required and some shared container hosting services may not
allow it. You should also be aware `--net=host` can be a security risk in some
situations. The [Center for Internet Security - Docker 1.6 Benchmark](https://github.com/cismirror/old-benchmarks-archive/blob/master/CIS_Docker_1.6_Benchmark_v1.0.0.pdf)
recommends against this mode since it essentially tells Docker to not
containerize the container's networking, thereby giving it full access to the
host machine's network interfaces. It also mentions this option could cause the
container to do unexpected things such as shutting down the Docker host as
referenced in [moby/moby#6401](https://github.com/moby/moby/issues/6401). For
the most secure deployment, unrelated services with confidential data should
not be run on the same host or VPS. In such cases, using `--net=host` should
have limited impact on security.

### Use with Pi-hole

[Pi-hole](https://pi-hole.net/) currently [provides documentation](https://docs.pi-hole.net/guides/dns-over-https/)
to manually set up DNS-Over-HTTPS with Cloudflared.

With Docker and this image, it's quite easy to use it with [Pi-hole](https://pi-hole.net/).
Take a look at this simple [docker compose template](examples/pihole/compose.yml),
and you're ready to go.

## Upgrade

To upgrade, pull the newer image and launch the container :

```bash
docker compose pull
docker compose up -d
```

## Contributing

Want to contribute? Awesome! The most basic way to show your support is to star the project, or to raise issues. You
can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) or by making
a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely!

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
