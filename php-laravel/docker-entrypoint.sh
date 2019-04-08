#!/bin/sh
set -e

# Fix permissions
usermod -a -G www-data root
chgrp -R www-data storage

chown -R www-data:www-data ./storage
chmod -R 0777 ./storage

# Start nginx
service nginx start

# Do Laravel things
php artisan down
php artisan migrate
php artisan up


exec "$@"
