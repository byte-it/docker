# Dockerfiles

## php-composer

Based on `php:cli` with composer installed and configured.
The image is intended to be used in gitlab ci

### Tags
- `7.1`
- `7.2`
- `7.3`

## php-laravel


## php-wp-bedrock

Based on `php:fpm` with nginx to serve wordpress from one container.
The Container is pre configured for a Bedrock Wordpress installation. 
WP CLI is pre installed. If the DB is clean, `wp core install [...]` will be run

### Tags
- `7.1`
- `7.2`
- `7.3`

### Environment Vars

For all possible vars look at [application.php](https://raw.githubusercontent.com/roots/bedrock/master/config/application.php)

#### Required
- `WP_HOME`
- `WP_THEME`
- `WP_TITLE`
- `DB_HOST`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`

Keys can be generated here https://roots.io/salts.html

- `AUTH_KEY`
- `SECURE_AUTH_KEY`
- `LOGGED_IN_KEY`
- `NONCE_KEY`
- `AUTH_SALT`
- `SECURE_AUTH_SALT`
- `LOGGED_IN_SALT`
- `NONCE_SALT`
