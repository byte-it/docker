FROM php:7.3-cli
LABEL maintainer="Johannes Kees <johannes@lets-byte.it>"

RUN apt-get update && apt-get install -y \
        git \
        libpq-dev \
        zlib1g-dev \
        libzip-dev \
        curl \
        nano \
        supervisor \
        nginx \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install  mbstring \
    && docker-php-ext-install  zip

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_NO_INTERACTION 1
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH

RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
