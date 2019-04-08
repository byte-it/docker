#!/bin/sh
set -e

# @TODO: Think about wrapping most of this stuff in a DB transaction..

# Bash script for checking whether WordPress is installed or not
if ! $(wp core is-installed --allow-root); then
    wp core install  --url="${WP_HOME}" --title="${WP_TITLE}" --admin_user=admin --admin_email=admin@lets-byte.it --allow-root
fi

# Make sure an updated WordPress can run its database-update
 wp core update-db --allow-root

# Make sure our custom Theme is always active 
wp theme activate ${WP_THEME} --allow-root

# Enable all Plugins by default, so new ones get enabled automatically
wp plugin activate --all --allow-root

# Clear Caches
wp cache flush --allow-root
wp transient delete --all --allow-root
# @TODO: Clear Super-Cache
# @TODO: Clear Twig-Cache

# @TODO: Run the Country-Pages-Generator Command here

# Start nginx
service nginx start

# @TODO: Start the Cache-Preflight Command here 

exec "$@"
