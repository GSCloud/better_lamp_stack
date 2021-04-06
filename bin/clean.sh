#!/bin/bash
#@author Filip Oščádal <git@gscloud.cz>

. bin/_includes.sh

command -v docker >/dev/null 2>&1 || fail "Docker is NOT installed!"

if [ ! -r ".env" ]; then fail "Missing .env file!"; fi
source .env

if [ -z ${APP_NAME+x} ]; then fail "Missing APP_NAME definition!"; fi
if [ -z ${DB_NAME+x} ]; then fail "Missing DB_NAME definition!"; fi
if [ -z ${PMA_NAME+x} ]; then fail "Missing PMA_NAME definition!"; fi

info "Removing containers"
docker rm ${APP_NAME} --force 2>/dev/null
docker rm ${DB_NAME} --force 2>/dev/null
docker rm ${PMA_NAME} --force 2>/dev/null

yes_or_no "Remove database?" && info "Removing database" && sudo rm -rf db/

exit 0
