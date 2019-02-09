FROM php:apache AS builder

RUN apt-get update && apt-get install -y \
        ca-certificates \
		git \
        zip \
        unzip \
        curl \
	--no-install-recommends && rm -r /var/lib/apt/lists/*

RUN git clone https://github.com/Westie/OUTRAGEdns.git /var/www/html \
    && git submodule update --init --recursive \
    && mkdir -p /opt/composer \
    && curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/opt/composer \
    && php /opt/composer/composer.phar install -o

FROM php:apache

COPY --from=builder /var/www/html /var/www/html

RUN chown -R www-data.www-data /var/www/html \
    && a2enmod rewrite expires remoteip