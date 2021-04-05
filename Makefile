#@author Filip Oščádal <git@gscloud.cz>
include .env

all: info

info:
	@echo "\e[1;32m👾 Welcome to ${PROJECT_NAME} 👾\n"

	@echo "🆘 \e[0;1mmake clean\e[0m - clean current installation"
	@echo "🆘 \e[0;1mmake config\e[0m - show Docker configuration"
	@echo "🆘 \e[0;1mmake extensions\e[0m - install PHP extensions"
	@echo "🆘 \e[0;1mmake docs\e[0m - build documentation"
	@echo "🆘 \e[0;1mmake install\e[0m - install containers"
	@echo "🆘 \e[0;1mmake remove\e[0m - remove containers"

docs:
	@echo "🔨 \e[1;32m Building documentation\e[0m"
	@bash ./bin/create_pdf.sh

install:
	@echo "🔨 \e[1;32m Installing\e[0m"
	@echo "Checking ..."
	@make config >/dev/null
	@bash ./bin/install.sh

extensions:
	@echo "🔨 \e[1;32m Installing extensions\e[0m"
	@bash ./bin/extensions.sh

remove:
	@echo "🔨 \e[1;32m Removing\e[0m"
	@bash ./bin/remove.sh

config:
	@echo "🔨 \e[1;32m Docker config\e[0m"
	@docker-compose config

clean:
	@echo "🔨 \e[1;32m Cleaning\e[0m"
	@docker rm ${APP_NAME} --force
	@docker rm ${DB_NAME} --force
	@docker rm ${PMA_NAME} --force
	sudo rm -rf db/

everything: remove install
