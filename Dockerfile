FROM catmandu-img

LABEL maintainer="Wolfgang Astleitner <wolfgang.astleitner@jku.at>"
ENV container=docker

COPY ebooks /var/www/apps/ebooks
COPY ebooks-fix /var/www/apps/ebooks-fix
COPY .git/modules/ebooks/refs/heads/master /var/www/apps/ebooks-fix/githash.txt

EXPOSE 80

RUN apt update \
    && apt install -y --no-install-recommends \
    apache2 apache2-utils php php-fpm php-common php-cli libapache2-mod-php liblwp-protocol-https-perl -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && mv /var/www/html/ebooks-fix/apache.conf /etc/apache2/sites-enabled/ebook-fix.conf

RUN sed -i 's/upload_max_filesize\s=\s2M/upload_max_filesize = 100M/g' /etc/php/8.2/apache2/php.ini
RUN sed -i 's/post_max_size\s=\s8M/post_max_size = 100M/g' /etc/php/8.2/apache2/php.ini

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
