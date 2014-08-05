[TOC]

# Heroku buildpack: WordPress on Heroku

*This is a Heroku buildpack for running [WordPress](http://wordpress.org) on [Heroku](http://heroku.com)*

## Summary

This project is based on the [heroku-buildpack-wordpress project by Marc Chung](https://github.com/mchung/heroku-buildpack-wordpress). It can be used with this [WordPress](http://github.com/mchung/wordpress-on-heroku) project template to bootstrap a highly tuned WordPress site built on the following stack:

* `nginx` - Nginx for serving web content.  Built specifically for Heroku.  [See compile options](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/support/heroku_package_nginx.sh).
* `php` - PHP-FPM for process management.  [See compile options](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/support/heroku_package_php.sh).
* `wordpress` - Downloaded directly [from wordpress.org](http://wordpress.org/download/release-archive/).
* `MySQL` - ClearDB for the MySQL backend.
* `Sendgrid` - Sendgrid for the email backend.
* `MemCachier` - MemCachier for the memcached backend.
* `Logentries` - Logentries for log management.
* `New Relic` - New Relic for real-time production monitoring.

## Overview

This buildpack bootstraps a WordPress site using the [mchung/wordpress-on-heroku](http://github.com/mchung/wordpress-on-heroku) project template.  That repo contains everything required to run your own WordPress site on Heroku.

This buildpack makes it possible to compile PHP and Nginx binaries on Heroku using the preferred `heroku run` command (due to [heroku vulcan being depreciated](https://github.com/heroku/vulcan)). These binaries are then uploaded to your Dropbox folder instead of Amazon S3 to reduce costs.

Each time WordPress is deployed, Heroku will fetch this buildpack from GitHub and execute the instructions in [bin/compile](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/bin/compile) and [bin/release](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/bin/release).

## Compile Vendored Packages

If your like me and you like to compile your own [PHP](http://php.net/downloads.php) and [Nginx](http://nginx.org/download/) binaries instead of relying on those compiled by someone else, then this section is for you. The `support` directory contains a handful of compilation and deployment scripts to automate several processes, which are currently used for maintenance and repo management.

* `heroku_package_all.sh` - Used to compile and upload the latest version of Nginx and PHP to Dropbox.
* `heroku_package_nginx.sh` - Used to compile and upload the latest version of Nginx to Dropbox.
* `heroku_package_php.sh` - Used to compile and upload the latest version of PHP to Dropbox.

For reference purposes, the original scripts from the forked project are:
* `package_nginx` - Used to compile and upload the latest version of Nginx to S3
* `package_php` - Used to compile and upload the latest version of PHP to S3.
* `wordup` - Really useful helper script for creating and destroying WordPress sites.

> If your using Windows or you would like to operate in a fresh virtual machine then a [Vagrantfile](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/Vagrantfile) has been included. For instructions on how to use this `Vagrantfile` see the [Vagrant website](http://www.vagrantup.com/).

### Usage

1. First clone this repo and create a new heroku app (replace `<app-name>` with the name of your app):

	```bash
	$ git clone https://github.com/CubicApps/heroku-buildpack-wordpress <app-name>
	$ cd <app-name>
	$ heroku apps:create <app-name> --remote <remote-name> --region <location>
	```

2. Then set these Heroku environment variables to your preferred versions using `$ heroku config:set`:

	```
	PHP_VERSION=5.5.15
	NGINX_VERSION=1.7.3
	PCRE_VERSION=8.35
	```

	For example, to build Nginx v1.7.3 with [PCRE](ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/) v8.35 execute these commands:

	```bash
	$ heroku config:set NGINX_VERSION=1.7.3 --app <app-name>
	$ heroku config:set PCRE_VERSION=8.35 --app <app-name>
	```

3. Push the repo to Heroku:

	For the master branch use:
	```bash
	$ git push <remote-name> master
	```
	
	For a local branch use:
	```bash
	$ git push <remote-name> <local-branch>:master
	```

4. Create a new one-off Heroku dyno and compile both PHP and Nginx:

	```bash
	$ heroku run bash --app <app-name>
	$ bash support/heroku_package_all.sh
	```

	Alternatively, if you only want to build PHP or Nginx, then you can execute [/support/heroku_package_php.sh](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/support/heroku_package_php.sh) or [/support/heroku_package_nginx.sh](https://github.com/CubicApps/heroku-buildpack-wordpress/blob/master/support/heroku_package_nginx.sh) instead.

5. When you're requested to authorise your Dropbox account, follow the on-screen instructions. 

	For reference:
	- Dropbox Developer Apps URL =  [https://www.dropbox.com/developers/apps](https://www.dropbox.com/developers/apps) 
	- Dropbox authorisation link = [https://www2.dropbox.com/1/oauth/authorize?oauth_token=`<token_value>`](https://www2.dropbox.com/1/oauth/authorize?oauth_token=).

> Note: If your using a text editor on Windows to create bash scripts, such as Notepad++, then make sure all carriage return characters `\r` are removed to prevent errors when executing the scripts.

## Bootstrapping a WordPress Site

This buildpack bootstraps a WordPress site using the [mchung/wordpress-on-heroku](http://github.com/mchung/wordpress-on-heroku) project template. That repo contains almost everything required to run your own WordPress site on Heroku. The only thing you need to add to your WordPress site is a `USE_DROPBOX` environment variable to control where the compiled binaries should be downloaded from (Dropbox or S3).

### Using Dropbox

To use Dropbox you must set the following environment variables:

* `USE_DROPBOX` - Set to `true`.
* `DROP_NGINX_URL` - Set to your Nginx Dropbox URL.
* `DROP_PHP_URL` - Set to your PHP Dropbox URL.

For example:

```bash
$ heroku config:set USE_DROPBOX=true --app <app-name>
$ heroku config:set DROP_NGINX_URL=https://www.dropbox.com/s/123456/nginx-1.7.3-heroku.tar.gz --app <app-name>
$ heroku config:set DROP_PHP_URL=https://www.dropbox.com/s/1234567/php-5.5.15-with-fpm-heroku.tar.gz --app <app-name>
```

### Using Pre-compiled Packages on S3

If you would like to use the pre-compiled vendor packages by [@mchung](https://github.com/mchung) then you should set the `USE_DROPBOX` environment variable to `false` in your WordPress site.

```bash
$ heroku config:set USE_DROPBOX=false --app <app-name>
```

See [VERSIONS](VERSIONS.md) for the specific versions of Nginx and PHP you can install.

## WordPress Version

This buildpack automatically installs the most current version of WordPress. However, if you would like to install an older version of WordPress, then set the `BUILDPACK_WORDPRESS_VERSION` environment variable to the version you would like to install.

For example, to install WordPress v3.8.2 use:

```bash
$ heroku config:set BUILDPACK_WORDPRESS_VERSION=3.8.2 --app <app-name>
```
