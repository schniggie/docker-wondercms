# PHP >= 8.4.27 is required: earlier releases are vulnerable to
# PHP2Shell (CVE-2026-109618, CVE-2026-109619), unauthenticated RCE in the
# PHP engine's request initialisation. Do not downgrade below the fixed release.
FROM php:8.4.27-apache
ENV DEBIAN_FRONTEND=noninteractive
ARG WONDERCMS_VERSION=3.6.0
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -yqu dist-upgrade && \
    apt-get -yq install --no-install-recommends git libzip-dev && \
    docker-php-ext-configure zip && \
    docker-php-ext-install -j$(nproc) zip && \
    git clone --depth 1 https://github.com/WonderCMS/wondercms.git -b $WONDERCMS_VERSION . && \
    rm -rf .git .github tests && \
    apt-get -yq purge git && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /var/log/apt/* && \
    mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini && \
    a2enmod rewrite && \
    chown -R www-data:www-data . && \
    chmod 755 .
# Defence in depth for PHP2Shell: disables the session upload progress path
# used by CVE-2026-109619. WonderCMS does not use upload progress tracking.
COPY php-hardening.ini $PHP_INI_DIR/conf.d/zz-hardening.ini
EXPOSE 80
