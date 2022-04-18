#!/bin/bash
#@author Fred Brooker <git@gscloud.cz>

if [ ! -f "./bin/_includes.sh" ]; then
    echo -en "\n\n\e[1;31mMissing _includes.sh file!\e[0m\n\n"
    exit 1
fi
. ./bin/_includes.sh

command -v docker >/dev/null 2>&1 || fail "Docker is NOT installed!"

if [ ! -r ".env" ]; then fail "Missing .env file!"; fi
source .env

###############################################################################

if [ -z ${APP_NAME+x} ]; then fail "Missing APP_NAME definition!"; fi
if [ -z ${APP_PORT+x} ]; then fail "Missing APP_PORT definition!"; fi
if [ -z ${DB_NAME+x} ]; then fail "Missing DB_NAME definition!"; fi
if [ -z ${PHP_CHECK_EXTENSIONS+x} ]; then fail "Missing PHP_CHECK_EXTENSIONS definition!"; fi
if [ -z ${PMA_NAME+x} ]; then fail "Missing PMA_NAME definition!"; fi
if [ -z ${PMA_PORT+x} ]; then fail "Missing PMA_PORT definition!"; fi

if [ -z "$(docker ps -a | grep ${APP_NAME})" ]; then fail "$APP_NAME is not running!"; fi
if [ -z "$(docker ps -a | grep ${PMA_NAME})" ]; then fail "$PMA_NAME is not running!"; fi
if [ -z "$(docker ps -a | grep ${DB_NAME})" ]; then fail "$DB_NAME is not running!"; fi

info "Containers"
docker-compose ps | grep -E "${APP_NAME}|${DB_NAME}|${PMA_NAME}"

if [ ! -z "$(docker ps | grep ${APP_NAME})" ]; then
    info "PHP Extensions"
    for i in ${PHP_CHECK_EXTENSIONS}
    do
        if [ -n "$(docker exec $APP_NAME php -m | grep $i)" ]; then
            echo -en "🆗 $i "
        else
            echo -en "❌️ $i "
        fi
    done
    echo -en "\n\n"

    echo -en "APP running at: \e[1;32mhttp://localhost:${APP_PORT}\e[0m\n"
    docker exec $APP_NAME php -i | grep 'memory_limit'
    docker exec $APP_NAME php -i | grep 'upload_max_filesize'
    echo -en "\n"

    echo -en "PMA running at: \e[1;32mhttp://localhost:${PMA_PORT}\e[0m\n"
    docker exec $PMA_NAME php -i | grep 'memory_limit'
    docker exec $PMA_NAME php -i | grep 'upload_max_filesize'
    echo -en "\n"
fi

exit 0
