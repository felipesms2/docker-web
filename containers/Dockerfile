FROM composer:2 AS composer

FROM felipesms/liga:1.2

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository --yes ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        php8.5-cli \
        libapache2-mod-php8.5 \
        php8.5-bcmath \
        php8.5-curl \
        php8.5-gd \
        php8.5-intl \
        php8.5-mbstring \
        php8.5-mongodb \
        php8.5-mysql \
        php8.5-redis \
        php8.5-sqlite3 \
        php8.5-xml \
        php8.5-zip \
    && update-alternatives --set php /usr/bin/php8.5 \
    && a2dismod php8.3 \
    && a2enmod php8.5 rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY envvars /etc/apache2/envvars

USER sites

WORKDIR /home/sites/apps

CMD ["/bin/bash"]
