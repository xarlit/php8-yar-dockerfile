FROM php:8.0-apache-buster

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev \
    zlib1g-dev \
    libpq-dev \
    zip \
    unzip \
	; \
	rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-install \
    bcmath \
    exif \
    sockets \
    pgsql \
    pdo_pgsql

RUN pecl install \
    yar-2.2.0 && docker-php-ext-enable yar.so \
    && pecl install redis && docker-php-ext-enable redis.so \
    && pecl install xlswriter && docker-php-ext-enable xlswriter

RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

#apache增加伪静态
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

WORKDIR /var/www/html
EXPOSE 80
CMD ["apache2-foreground"]
