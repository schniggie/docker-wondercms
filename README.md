# docker-wondercms
Docker image for WonderCMS, a flat file CMS (<https://www.wondercms.com/>).

This image relies on Debian Linux, Apache 2 and PHP 8.4, and ships WonderCMS from <https://github.com/WonderCMS/wondercms>.

## Security

The base image is pinned to `php:8.4.27-apache`, the first 8.4 release fixing
PHP2Shell ([CVE-2026-109618](https://www.cve.org/CVERecord?id=CVE-2026-109618),
[CVE-2026-109619](https://www.cve.org/CVERecord?id=CVE-2026-109619)), an
unauthenticated RCE in the PHP engine. Images built from PHP 7.4 (all tags of this
image up to WonderCMS 3.3.4) are vulnerable: rebuild and replace running containers.

Additional hardening in `php-hardening.ini`:

- `session.upload_progress.enabled = 0` (removes the known CVE-2026-109619 path)
- `expose_php = Off`
- `php.ini-production` defaults (`display_errors = Off`)

## Building

```
$ docker build -t wondercms .
$ docker build --build-arg WONDERCMS_VERSION=3.6.0 --build-arg PHP_VERSION=8.4.27 -t wondercms .
```

Do not set `PHP_VERSION` below 8.4.27 (or 8.2.35 / 8.3.36 / 8.5.12 on other branches).

## How to use this image

This will start a Wonder CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name wondercms mablanco/wondercms
```

If you'd like persistance, you can create a volume for that purpose:

```
$ docker volume create wondercms_web
$ docker run -d -p 80:80 --name wondercms -v wondercms_web:/var/www/html mablanco/wondercms
```
