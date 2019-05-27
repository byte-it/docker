#!/bin/bash
set -e

# Store the current working directory to pass it to further scripts
WORKING_DIR="$(pwd)"

# Fix permissions
usermod -a -G www-data root
chgrp -R www-data storage

chown -R www-data:www-data ./storage
chmod -R 0777 ./storage

# Do Laravel things
php artisan down
php artisan migrate
php artisan up

# Call custom scripts for pre-running here
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

# Start nginx
service nginx start

exec "$@"
