#!/bin/sh

# execute the NGINX build process
bash heroku_package_nginx.sh

# execute the PHP build process
bash heroku_package_php.sh
