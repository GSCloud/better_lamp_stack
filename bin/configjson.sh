#!/bin/bash
#@author Fred Brooker <git@gscloud.cz>

if [ ! -f "./bin/_includes.sh" ]; then
    echo -en "\n\n\e[1;31mMissing _includes.sh file!\e[0m\n\n"
    exit 1
fi
. ./bin/_includes.sh

command -v ruby >/dev/null 2>&1 || fail "Ruby is NOT installed!"

docker-compose config | ruby -r yaml -r json -e 'puts YAML.load($stdin.read).to_json'

exit 0
