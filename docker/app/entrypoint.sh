#!/bin/sh
WORKSPACE="/var/www/app"

cd $WORKSPACE

# migration
php artisan migrate --force

# optimize
php artisan optimize

# start supervisord
supervisord -c /etc/supervisor/supervisord.conf

# php fpm
php-fpm -F
