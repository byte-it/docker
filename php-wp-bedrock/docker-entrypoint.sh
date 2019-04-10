#!/bin/sh
set -e

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
# Call custom scripts here!
#php bin/console cached-files:clear
# Generate the Country-Page Skeletons in WordPress, if they're not already there
#php bin/console country-pages:generate

# Start nginx
service nginx start

# Think about how to do this
# Generate the Country-Page Caches by calling all of them via HTTP
#php bin/console country-pages:pre-flight

exec "$@"
