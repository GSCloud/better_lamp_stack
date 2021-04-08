#!/bin/bash
#@author Filip Oščádal <git@gscloud.cz>

. bin/_includes.sh

command -v docker >/dev/null 2>&1 || fail "Docker is NOT installed!"

if [ ! -r ".env" ]; then fail "Missing .env file!"; fi
source .env

if [ -z ${APP_NAME+x} ]; then fail "Missing APP_NAME definition!"; fi
if [ -z ${APP_PORT+x} ]; then fail "Missing APP_PORT definition!"; fi
if [ -z ${CHECK_EXTENSIONS+x} ]; then fail "Missing CHECK_EXTENSIONS definition!"; fi
if [ -z ${DB_NAME+x} ]; then fail "Missing DB_NAME definition!"; fi
if [ -z ${PMA_NAME+x} ]; then fail "Missing PMA_NAME definition!"; fi
if [ -z ${PMA_PORT+x} ]; then fail "Missing PMA_PORT definition!"; fi

info "Docker containers"
docker-compose ps
echo -en "\n"

if [ -z "$(docker ps -a | grep ${APP_NAME})" ]; then fail "$APP_NAME is not running!"; fi

info "PHP extensions"
for i in ${CHECK_EXTENSIONS}
do
    if [ -n "$(docker exec $APP_NAME php -m | grep $i)" ]; then echo "🆗 $i"; else echo "❌️ $i"; fi
done
echo -en "\n"

info "APP limits"
docker exec $APP_NAME php -i | grep 'memory_limit'
docker exec $APP_NAME php -i | grep 'upload_max_filesize'
echo -en "\n"

info "PMA limits"
docker exec $PMA_NAME php -i | grep 'memory_limit'
docker exec $PMA_NAME php -i | grep 'upload_max_filesize'
echo -en "\n"

info "APP"
echo -en "http://localhost:${APP_PORT}\n\n"

info "PMA"
echo -en "http://localhost:${PMA_PORT}\n\n"

exit 0
