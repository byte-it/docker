#!/bin/sh

# Store the current working directory to pass it to further scripts
WORKING_DIR="$(pwd)"

php vendor/bin/drush status bootstrap | grep -q Successful

if [[ $0 > 0 ]]
then
    DRUPAL_INSTALLED = 1
else
    DRUPAL_INSTALLED = 0
fi

set -e

PRE_SCRIPTS_DIR=/var/scripts/pre
AFTER_SCRIPTS_DIR=/var/scripts/after

if [[ -d "$PRE_SCRIPTS_DIR" ]]; then
  PRE_SCRIPTS="$PRE_SCRIPTS_DIR/*.sh"
  for script in ${PRE_SCRIPTS}; do
	  [[ -f ${script} && -x ${script} ]] && bash ${script} ${WORKING_DIR}
	done
fi

set -e

# Get a config diff before continuing
rm config/config-diff.yml
php vendor/bin/drush config:status  --format=yaml 1> config/config-diff.yml

if [[ -s "config/config-diff.yml" ]]
then
    php vendor/bin/drush config:export -y
    exit 10
fi
# Lets get sirius and turn on maintenance
php vendor/bin/drush state:set system.maintenance_mode 1

# Update config ignore settings first (need drupal console because drush can't import a single file)
php vendor/bin/drupal config:import:single --file "live/config/sync/config_ignore.settings.yml"

# Apply all needed updates
php vendor/bin/drush config:import -y
php vendor/bin/drush entity:updates -y
php vendor/bin/drush updatedb -y

# Load the newest translations
php vendor/bin/drush locale:update

# we're done here, turn it back on
php vendor/bin/drush state:set system.maintenance_mode 0

# Call custom scripts for pre-running here
if [[ -d "$AFTER_SCRIPTS_DIR" ]]; then
  AFTER_SCRIPTS="$AFTER_SCRIPTS_DIR/*.sh"
  for script in ${AFTER_SCRIPTS}; do
	  [[ -f ${script} && -x ${script} ]] && bash ${script} ${WORKING_DIR}
	done
fi

# Start nginx
service nginx start

exec "$@"