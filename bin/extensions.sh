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
if [ -z ${APT_EXTRAS+x} ]; then fail "Missing APT_EXTRAS definition!"; fi
if [ -z ${CMD_EXTRAS1+x} ]; then fail "Missing CMD_EXTRAS1 definition!"; fi
if [ -z ${CMD_EXTRAS2+x} ]; then fail "Missing CMD_EXTRAS2 definition!"; fi
if [ -z ${PHP_EXTENSIONS+x} ]; then fail "Missing PHP_EXTENSIONS definition!"; fi

# check if container is running
if [ -z "$(docker ps | grep ${APP_NAME})" ]; then fail "$APP_NAME is not running!"; fi

echo "Updating container APT"
docker exec $APP_NAME apt-get update -yqq

# command extras #1
if [ ! -z "${CMD_EXTRAS1}" ]; then
    docker exec $APP_NAME ${CMD_EXTRAS1}
fi

# APT install
if [ ! -z "${APT_EXTRAS}" ]; then
    docker exec $APP_NAME apt-get install -yq ${APT_EXTRAS}
fi

# PHP extensions install
if [ ! -z "${PHP_EXTENSIONS}" ]; then
    docker exec $APP_NAME docker-php-ext-install ${PHP_EXTENSIONS}
fi

# command extras #2
if [ ! -z "${CMD_EXTRAS2}" ]; then
    docker exec $APP_NAME ${CMD_EXTRAS2}
fi

info "Restarting container"
docker restart $APP_NAME

exit 0
