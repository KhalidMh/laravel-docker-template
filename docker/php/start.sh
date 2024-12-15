#!/bin/sh

# wait for mysql to start
while ! mysqladmin ping -h "mysql" --silent; do
    sleep 1
done

# run any artisan commands
# php artisan migrate

# start php-fpm
php-fpm -y /usr/local/etc/php-fpm.conf -R
