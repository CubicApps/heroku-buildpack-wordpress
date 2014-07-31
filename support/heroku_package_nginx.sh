#!/bin/sh

set -e

if [ "$NGINX_VERSION" == "" ]; then
  echo "must set NGINX_VERSION environment variable, i.e. $ export NGINX_VERSION=1.7.3"
  exit 1
fi
if [ "$PCRE_VERSION" == "" ]; then
  echo "must set PCRE_VERSION environment variable, i.e. $ export PCRE_VERSION=8.35"
  exit 1
fi

# download and extract nginx
rm -rf /app/vendor/nginx
curl http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o /tmp/nginx.tgz
cd /tmp
tar xzvf nginx.tgz

# download and extract pcre into contrib directory
cd nginx-$NGINX_VERSION/contrib
curl ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz -o pcre.tgz
tar zvxf pcre.tgz

# build and package nginx for heroku
cd /tmp/nginx-$NGINX_VERSION
./configure --prefix=/app/vendor/nginx \
  --with-pcre=contrib/pcre-$PCRE_VERSION \
  --with-http_ssl_module \
  --with-http_gzip_static_module \
  --with-http_stub_status_module \
  --with-http_realip_module
make install
cd /app/vendor/nginx
tar cvfz /tmp/nginx-$NGINX_VERSION-heroku.tar.gz .

# check Dropbox-Uploader is connected
bash /app/support/drop/dropbox_uploader.sh info
# upload to dropbox using Dropbox-Uploader
cd /tmp/
bash /app/support/drop/dropbox_uploader.sh -s upload nginx-$NGINX_VERSION-heroku.tar.gz /nginx/nginx-$NGINX_VERSION-heroku.tar.gz
