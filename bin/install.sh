#!/bin/bash
#@author Filip Oščádal <git@gscloud.cz>

. bin/_includes.sh

command -v docker >/dev/null 2>&1 || fail "Docker is NOT installed!"

if [ ! -r ".env" ]; then fail "Missing .env file!"; fi
source .env

if [ -z "$APP_NAME" ]; then fail "Missing APP_NAME definition!"; fi
if [ -z "$DB_NAME" ]; then fail "Missing DB_NAME definition!"; fi
if [ -z "$PMA_NAME" ]; then fail "Missing PMA_NAME definition!"; fi

mkdir -p db

info "Stopping containers"
docker stop $APP_NAME 2>/dev/null
docker stop $DB_NAME 2>/dev/null
docker stop $PMA_NAME 2>/dev/null

docker-compose up -d
echo -en "\n"

docker-compose ps
echo -en "\n"

info "APP settings:"
docker exec $APP_NAME php -i | grep 'memory_limit'
docker exec $APP_NAME php -i | grep 'upload_max_filesize'
echo -en "\n"

info "PHP extensions:"
docker exec $APP_NAME php -m | grep mysqlnd
docker exec $APP_NAME php -m | grep mysqli
echo -en "\n"

info "PMA settings:"
docker exec $PMA_NAME php -i | grep 'memory_limit'
docker exec $PMA_NAME php -i | grep 'upload_max_filesize'
echo -en "\n"

exit 0
