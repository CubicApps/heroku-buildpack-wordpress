#!/bin/sh

# execute the NGINX build process
bash support/heroku_package_nginx.sh

# execute the PHP build process
bash support/heroku_package_php.sh
