#@author Fred Brooker <git@gscloud.cz>
include .env
all: info

info:
	@echo "\e[1;32m👾 Welcome to ${PROJECT_NAME}"
	@echo ""
	@echo "\e[0mApp environment: \t\e[0;1mPHP\e[0m ${APP_IMAGE} \e[0;1mMySQL\e[0m ${DB_IMAGE}"
	@echo "\e[0mPHP extensions: \t${PHP_CHECK_EXTENSIONS}"
	@echo ""
	@echo "🆘 \e[0;1mmake docs\e[0m \t\t- build documentation"
	@echo "🆘 \e[0;1mmake config\e[0m \t\t- show Docker configuration"
	@echo "🆘 \e[0;1mmake configjson\e[0m \t\t- show Docker configuration in JSON format"
	@echo ""
	@echo "🆘 \e[0;1mmake install\e[0m \t- install and start containers"
	@echo "🆘 \e[0;1mmake extensions\e[0m \t- install PHP extensions"
	@echo "🆘 \e[0;1mmake start\e[0m \t\t- resuming containers"
	@echo "🆘 \e[0;1mmake stop\e[0m \t\t- stop containers"
	@echo "🆘 \e[0;1mmake check\e[0m \t\t- check configuration"
	@echo "🆘 \e[0;1mmake exec\e[0m \t\t- execute bash in the app container"
	@echo ""
	@echo "🆘 \e[0;1mmake remove\e[0m \t\t- remove containers (data will stay)"
	@echo "🆘 \e[0;1mmake purge\e[0m \t\t- purge current installation (DATA WILL VANISH!)"
	@echo ""
docs:
	@echo "🔨 \e[1;32m Building documentation\e[0m"
	@bash ./bin/create_pdf.sh
install:
	@echo "🔨 \e[1;32m Installing containers\e[0m"
	@bash ./bin/install.sh
extensions:
	@echo "🔨 \e[1;32m Installing PHP extensions\e[0m"
	@bash ./bin/extensions.sh
	@make check
remove:
	@echo "🔨 \e[1;32m Removing containers\e[0m"
	@bash ./bin/remove.sh
stop:
	@echo "🔨 \e[1;32m Stopping containers\e[0m"
	@bash ./bin/stop.sh
start:
	@echo "🔨 \e[1;32m Resuming containers\e[0m"
	@bash ./bin/start.sh
config:
	@echo "🔨 \e[1;32m Configuration\e[0m"
	@docker-compose config
configjson:
	@bash ./bin/configjson.sh
check:
	@echo "🔨 \e[1;32m Checking configuration\e[0m"
	@bash ./bin/check.sh
exec:
	@bash ./bin/execbash.sh
purge:
	@echo "🔨 \e[1;32m Purging installation\e[0m"
	@bash ./bin/purge.sh

# classic installation of everything
everything: remove install extensions
