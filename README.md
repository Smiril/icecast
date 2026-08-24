# [icecast](https://github.com/Smiril/icecast)  <a href="https://github.com/Smiril/icecast/actions/workflows/docker-publish.yml"><img src="https://github.com/Smiril/icecast/actions/workflows/docker-publish.yml/badge.svg"></a>
<p align="center">
  <a href="//github.com/Smiril/icecast"><img src="https://img.shields.io/github/repo-size/Smiril/icecast"></a>
  <a href="//github.com/Smiril/icecast/commits"><img src="https://img.shields.io/github/last-commit/Smiril/icecast"></a>
  <a href="//github.com/Smiril/icecast/contributors"><img src="https://img.shields.io/github/contributors/Smiril/icecast"></a>
  <a href="https://github.com/Smiril/icecast/actions/workflows/container.yml"><img src="https://github.com/Smiril/icecast/actions/workflows/container.yml/badge.svg"></a>
  <a href="https://github.com/Smiril/icecast/actions/workflows/project.yml"><img src="https://github.com/Smiril/icecast/actions/workflows/project.yml/badge.svg"></a>
</p>

This [project](https://github.com/Smiril/icecast) provide icecast container images.

While the image is under the Smiril namespace, anyone can use it! This image will not add any LibreTime specific features, and will not deviate from upstream.

```bash
docker run -d -p 8000:8000 Smiril/icecast:2.5.0
docker run -d -p 8000:8000 ghcr.io/Smiril/icecast:2.5.0
```

The following icecast tags are supported:

- `2.5.0-debian`, `2.5.0`, `debian`, `latest`
- `2.5.0-fedora`, `fedora`
- `2.5.0-ubuntu`, `ubuntu`
- `2.5.0-alpine`, `alpine`

> If the underlying system packages or the base images are updated, a newer docker image will be build. The tags will always point to the newer images. To prevent unexpected images updates, we suggest you to pin the image by adding its sha256 digest, for example `2.5.0@sha256:56e6f265675f07a80c4164f48b2ed6f3d371aed78a334c666dd2eda0d97afc5e`.
>
> You can use the following command to get an image sha256 digest:
>
> ```bash
> docker inspect --format='{{index .RepoDigests 0}}' ghcr.io/Smiril/icecast:2.5.0-debian
> ```

The default configuration file (`/etc/icecast.xml`) was updated with following changes:

- `/icecast/logging/errorlog=-` print logs to stdout instead of log file.

You can tweak the configuration using the following environment variables:

- `ICECAST_SOURCE_PASSWORD`
- `ICECAST_RELAY_PASSWORD`
- `ICECAST_ADMIN_PASSWORD`
- `ICECAST_ADMIN_USERNAME`
- `ICECAST_ADMIN_EMAIL`
- `ICECAST_LOCATION`
- `ICECAST_HOSTNAME`
- `ICECAST_MAX_CLIENTS`
- `ICECAST_MAX_SOURCES`
- `ICECAST_TLS_CERT`
- `ICECAST_TLS_KEY`

Or you can mount your own configuration file in the container:

```bash
docker run -d \
    -p 8000:8000 \
    --dns 1.1.1.1 \
    --dns-search hackme.org \
    -e ICECAST_SOURCE_PASSWORD=hackme \
    -e ICECAST_RELAY_PASSWORD=hackme \
    -e ICECAST_ADMIN_PASSWORD=hackme \
    -e ICECAST_ADMIN_USERNAME=toor \
    -e ICECAST_ADMIN_EMAIL=example@hackme.org \
    -e ICECAST_LOCATION=Dallas \
    -e ICECAST_HOSTNAME=hackme.org \
    -e ICECAST_MAX_CLIENTS=100 \
    -e ICECAST_MAX_SOURCES=2 \
    -e ICECAST_TLS_CERT=/etc/mycert.pem \
    -e ICECAST_TLS_KEY=/etc/mykey.pem \
    -v /full/path/cert.pem:/etc/mycert.pem \
    -v /full/path/key.pem:/etc/mykey.pem \
    Smiril/icecast:2.5.0-alpine
```

```bash
docker run -d \
    -p 8000:8000 \
    --dns 1.1.1.1 \
    --dns-search hackme.org \
    -v /full/path/icecast.xml:/etc/icecast.xml \
    -v /full/path/cert.pem:/etc/cert.pem \
    -v /full/path/key.pem:/etc/key.pem \
    Smiril/icecast:2.5.0-debian
```
