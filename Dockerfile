# syntax=docker/dockerfile:1

FROM php:8.4

LABEL org.opencontainers.image.authors="Michael Dzjaparidze"

ENV TZ=UTC

RUN ln --force --no-dereference --symbolic /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends git openssh-client libzip-dev libjpeg62-turbo-dev libpng-dev libmagickwand-dev ghostscript npm \
    && apt-get autoremove --yes && apt-get clean \
    && rm --force --recursive /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install gd pcntl exif pdo_mysql zip intl \
    && curl --show-error --silent https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && pecl install xdebug-3.4.0beta1 \
    && docker-php-ext-enable xdebug \
    && echo xdebug.mode=coverage > /usr/local/etc/php/conf.d/xdebug.ini \
    && git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick \
    && cd /tmp/imagick \
    && git fetch origin master \
    && git switch master \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick \
    && rm --recursive --force /tmp/* \
    && sed --in-place '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml

