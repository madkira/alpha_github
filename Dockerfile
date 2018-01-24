FROM php:5.6-apache

ENV DOLI_VERSION 3.7.0

ENV DOLI_INSTALL_AUTO 1

ENV DOLI_DB_HOST mysql
ENV DOLI_DB_USER doli
ENV DOLI_DB_PASSWORD doli_pass
ENV DOLI_DB_NAME dolidb

ENV DOLI_ADMIN_LOGIN admin
ENV DOLI_ADMON_PASSWORD admin
ENV DOLI_URL_ROOT 'http://localhost'

ENV WWW_USER_ID 33
ENV WWW_GROUP_ID 33

ENV PHP_INI_DATE_TIMEZONE 'UTC'

RUN apt-get update -q && apt-get upgrade -yq \
	&& apt-get install -yq \
		libpng12-dev \
		libjpeg-dev \
    php5-mysql \
    libxml2-dev \
    mysql-client \
		unzip \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli soap zip

# Get Dolibarr
ADD https://github.com/Dolibarr/dolibarr/archive/${DOLI_VERSION}.zip /tmp/dolibarr.zip
RUN unzip -q /tmp/dolibarr.zip -d /tmp/dolibarr
RUN cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/htdocs/* /var/www/html/ && ln -s /var/www/html /var/www/htdocs
RUN cp -r /tmp/dolibarr/dolibarr-${DOLI_VERSION}/scripts /var/www/
RUN rm -rf /tmp/dolibarr

RUN chown -hR www-data:www-data /var/www/html



VOLUME /var/www/html/conf
VOLUME /var/www/html/documents

EXPOSE 80

COPY docker-run.sh /usr/local/bin/
ENTRYPOINT ["docker-run.sh"]
