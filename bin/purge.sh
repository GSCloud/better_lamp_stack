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
if [ -z ${DB_NAME+x} ]; then fail "Missing DB_NAME definition!"; fi
if [ -z ${DB_VOLUME+x} ]; then fail "Missing DB_VOLUME definition!"; fi
if [ -z ${PMA_NAME+x} ]; then fail "Missing PMA_NAME definition!"; fi

if [ -z "$(docker ps -a | grep ${APP_NAME})" ]; then
    echo "$APP_NAME is not running"
else
    info "Removing: $APP_NAME"
    docker rm ${APP_NAME} --force 2>/dev/null
fi

if [ -z "$(docker ps -a | grep ${PMA_NAME})" ]; then
    echo "$PMA_NAME is not running"
else
    info "Removing: $PMA_NAME"
    docker rm ${PMA_NAME} --force 2>/dev/null
fi

if [ -z "$(docker ps -a | grep ${DB_NAME})" ]; then
    echo "$DB_NAME is not running"
else
    info "Removing: $DB_NAME"
    docker rm ${DB_NAME} --force 2>/dev/null
fi

if [ -d "$DB_VOLUME" ]; then
    yes_or_no "Remove database?" && info "Removing database folder" && sudo rm -rf "$DB_VOLUME"
fi

exit 0
