#!/bin/sh

set -e

if [ "$PHP_VERSION" == "" ]; then
  echo "must set PHP_VERSION environment variable, i.e. $ export PHP_VERSION=5.5.15"
  exit 1
fi

# download and extract php
rm -rf /app/vendor/php
curl -L http://uk1.php.net/get/php-$PHP_VERSION.tar.bz2/from/this/mirror -o /tmp/php.tar.bz2
cd /tmp
tar xvjf php.tar.bz2

# build and package php for heroku
cd php-$PHP_VERSION
./configure --prefix=/app/vendor/php \
			--with-mysql \
			--with-pdo-mysql \
			--with-iconv \
			--with-gd \
			--with-curl=/usr/lib \
			--with-config-file-path=/app/vendor/php \
			--with-openssl \
			--enable-fpm \
			--with-zlib \
			--enable-mbstring \
			--disable-debug \
			--disable-rpath \
			--enable-gd-native-ttf \
			--enable-inline-optimization \
			--with-bz2 \
			--enable-pcntl \
			--enable-mbregex \
			--with-mhash \
			--enable-zip \
			--with-pcre-regex \
			--enable-libxml \
			--with-gettext \
			--with-jpeg-dir \
			--with-mysqli \
			--with-pcre-regex \
			--with-png-dir \
			--without-pdo-sqlite \
			--without-sqlite3
make install
/app/vendor/php/bin/pear config-set php_dir /app/vendor/php
yes '' | /app/vendor/php/bin/pecl install memcache
cd /app/vendor/php
tar cvfz /tmp/php-$PHP_VERSION-with-fpm-heroku.tar.gz .

# upload to dropbox using Dropbox-Uploader
cd /tmp/
bash /app/support/drop/dropbox_uploader.sh -s upload php-5.5.15-with-fpm-heroku.tar.gz /php/php-5.5.15-with-fpm-heroku.tar.gz
