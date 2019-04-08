#!/bin/sh
set -e

# Bash script for checking whether WordPress is installed or not
if ! $(wp core is-installed --allow-root); then
    wp core install  --url="${WP_HOME}" --title="${WP_TITLE}" --admin_user=admin --admin_email=admin@lets-byte.it --allow-root
fi

wp theme activate ${WP_THEME}  --allow-root
wp plugin activate --all  --allow-root


# Start nginx
service nginx start

exec "$@"
