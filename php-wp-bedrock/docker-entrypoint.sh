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

# Call custom scripts for pre-running here
PRE_SCRIPTS_DIR=/var/scripts/pre
if [ -d "$PRE_SCRIPTS_DIR" ]; then
  PRE_SCRIPTS="$PRE_SCRIPTS_DIR/*.sh"
  for script in $PRE_SCRIPTS; do
        [[ -f $script && -x $script ]] && bash $script
  done
fi


# Start nginx
service nginx start

exec "$@"
