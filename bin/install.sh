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

# make DB volume
mkdir -p "${DB_VOLUME}"

info "Stopping containers"
docker stop $APP_NAME 2>/dev/null
docker stop $PMA_NAME 2>/dev/null
docker stop $DB_NAME 2>/dev/null

info "Installing containers"
docker-compose up -d
docker exec $APP_NAME cp -u /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
docker exec $APP_NAME pear config-set php_ini /usr/local/etc/php/php.ini

info "Restarting container"
docker restart $APP_NAME

echo ""

exit 0
