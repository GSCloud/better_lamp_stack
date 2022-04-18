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
if [ -z ${CMD_EXTRAS+x} ]; then fail "Missing CMD_EXTRAS definition!"; fi
if [ -z ${PHP_EXTENSIONS+x} ]; then fail "Missing PHP_EXTENSIONS definition!"; fi

# check if container is running
if [ -z "$(docker ps -a | grep ${APP_NAME})" ]; then fail "$APP_NAME is not running!"; fi

echo "Updating container APT"
docker exec $APP_NAME apt-get update -yqq

# APT install
if [ ! -z "${APT_EXTRAS}" ]; then
    docker exec $APP_NAME apt-get install -yq ${APT_EXTRAS}
fi

# PHP extensions install
if [ ! -z "${PHP_EXTENSIONS}" ]; then
    docker exec $APP_NAME docker-php-ext-install ${PHP_EXTENSIONS}
fi

# extra command
if [ ! -z "${CMD_EXTRAS}" ]; then
    docker exec $APP_NAME ${CMD_EXTRAS}
fi

docker restart $APP_NAME

exit 0
