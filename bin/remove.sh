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
if [ -z ${PMA_NAME+x} ]; then fail "Missing PMA_NAME definition!"; fi

info "Stopping containers"
docker stop $APP_NAME 2>/dev/null
docker stop $PMA_NAME 2>/dev/null
docker stop $DB_NAME 2>/dev/null

info "Removing containers"
docker rm $APP_NAME 2>/dev/null
docker rm $PMA_NAME 2>/dev/null
docker rm $DB_NAME 2>/dev/null

echo ""

exit 0
