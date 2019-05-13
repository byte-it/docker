#!/bin/bash

# Store the current working directory to pass it to further scripts
WORKING_DIR="$(pwd)"

DRUPAL_INSTALLED=0

php vendor/bin/drush status bootstrap | grep -q Successful


if [[ $? = 0 ]]
then
    DRUPAL_INSTALLED=1
    echo "Drupal is installed"
else
    echo "Drupal isn't installed"
fi

set -e


if [[ -d "$PRE_SCRIPTS_DIR" ]]; then
    PRE_SCRIPTS="$PRE_SCRIPTS_DIR/*.sh"

    for script in ${PRE_SCRIPTS}; do
        if [[ -f ${script} && -x ${script} ]]; then
            echo "Execute ${script}"
            source ${script} ${WORKING_DIR}
            echo "Finished ${script}"
        fi
    done
fi

set -e

# Get a config diff before continuing
if [ -f config/config-diff.yml ]
then
    rm config/config-diff.yml
fi

php vendor/bin/drush config:status  --format=yaml 1> config/config-diff.yml

if [ -s "config/config-diff.yml" ]
then
    php vendor/bin/drush cex --destination ../config/old
fi
# Lets get sirius and turn on maintenance
php vendor/bin/drush state:set system.maintenance_mode 1

if [[ DRUPAL_INSTALLED = 1 ]]; then
    # Update config ignore settings first (need drupal console because drush can't import a single file)
    php vendor/bin/drupal config:import:single --file "live/config/sync/config_ignore.settings.yml"

    # Apply all needed updates
    php vendor/bin/drush config:import -y
fi

php vendor/bin/drush entity:updates -y
php vendor/bin/drush updatedb -y

# Load the newest translations
#php vendor/bin/drush locale:update

# we're done here, turn it back on
php vendor/bin/drush state:set system.maintenance_mode 0

# Call custom scripts for pre-running here

if [[ -d "$AFTER_SCRIPTS_DIR" ]]; then
    AFTER_SCRIPTS="$AFTER_SCRIPTS_DIR/*.sh"

    for script in ${AFTER_SCRIPTS}; do
        if [[ -f ${script} && -x ${script} ]]; then
            echo "Execute ${script}"
            source ${script} ${WORKING_DIR}
            echo "Finished ${script}"
        fi
    done
fi

# Start nginx
service nginx start

exec "$@"