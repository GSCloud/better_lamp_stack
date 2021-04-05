#!/bin/bash
#@author Filip Oščádal <git@gscloud.cz>

. bin/_includes.sh

command -v docker >/dev/null 2>&1 || fail "Docker is NOT installed!"

if [ ! -r ".env" ]; then fail "Missing .env file!"; fi
source .env

if [ -z "$APP_NAME" ]; then fail "Missing APP_NAME definition!"; fi
if [ -z "$DB_NAME" ]; then fail "Missing DB_NAME definition!"; fi
if [ -z "$PMA_NAME" ]; then fail "Missing PMA_NAME definition!"; fi

info "Killing containers"
docker kill $APP_NAME 2>/dev/null
docker kill $PMA_NAME 2>/dev/null
docker kill $DB_NAME 2>/dev/null

exit 0
