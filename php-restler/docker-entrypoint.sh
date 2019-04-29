#!/bin/sh
set -e

# Store the current working directory to pass it to further scripts
WORKING_DIR="$(pwd)"

# Call custom scripts for pre-running here
PRE_SCRIPTS_DIR=/var/scripts/pre
if [ -d "$PRE_SCRIPTS_DIR" ]; then
  PRE_SCRIPTS="$PRE_SCRIPTS_DIR/*.sh"
  for script in $PRE_SCRIPTS; do
	  [[ -f $script && -x $script ]] && bash $script $WORKING_DIR
	done
fi


# Start nginx
service nginx start

exec "$@"
