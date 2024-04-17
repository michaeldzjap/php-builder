# syntax=docker/dockerfile:1
FROM php:8.2
LABEL org.opencontainers.image.authors="Michael Dzjaparidze"

RUN apt-get update --yes --quiet \
    && apt-get install --yes --quiet --no-install-recommends git openssh-client libzip-dev libjpeg-dev libpng-dev ghostscript libmagickwand-dev npm \
    && rm -rf /var/cache/apt/lists/* \
    && docker-php-ext-configure gd --enable-gd --with-jpeg \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install gd pcntl exif pdo_mysql zip \
    && curl --show-error --silent https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && pecl install xdebug imagick \
    && docker-php-ext-enable xdebug imagick \
    && echo xdebug.mode=coverage > /usr/local/etc/php/conf.d/xdebug.ini \
    && sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml

