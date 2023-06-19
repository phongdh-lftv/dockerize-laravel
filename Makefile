# Sets the default goal to be used if no targets were specified on the command line
.DEFAULT_GOAL := help

# Internal variables || Optional args
root_path := $(shell dirname -- `pwd`)
docker_folder ?= ./docker

# -include .env
# export

COMPOSE_PROJECT_NAME_SHELL := ${COMPOSE_PROJECT_NAME}
CONTAINER_VERSION_SHELL := ${CONTAINER_VERSION}

ifneq ("$(wildcard .env)","")
include .env
export
endif

# Handling environment variables
PROJECT_NAME := $(if $(COMPOSE_PROJECT_NAME_SHELL),$(COMPOSE_PROJECT_NAME_SHELL),$(COMPOSE_PROJECT_NAME))
APP_URL_CONF = "${docker_folder}/nginx/app-site.conf"

DOCKER_BUILD_EXEC := docker build

PHP_FPM_TAGET := php-fpm-${APP_ENV}
PHP_FPM_IMAGE := "${PROJECT_NAME}/${PHP_FPM_TAGET}:latest"

NGINX_TAGET := nginx
NGINX_IMAGE := "${PROJECT_NAME}/${NGINX_TAGET}:latest"

# Internal functions
define message_failure
	"\033[1;31m ❌$(1)\033[0m"
endef

define message_success
	"\033[1;32m ✅$(1)\033[0m"
endef

define message_info
	"\033[0;34m❕$(1)\033[0m"
endef

build:
	@echo
	@echo $(call message_info, Build your images)
	@echo
	@cp -n .env.example .env || true
	@cp -n "$(APP_URL_CONF).example" $(APP_URL_CONF) || true
	@sed -i '' 's/server_name  __;/server_name  $(APP_URL);/g' $(APP_URL_CONF)
	@sed -i '' 's/fastcgi_pass _:9000;/fastcgi_pass $(PROJECT_NAME)-app:9000;/g' $(APP_URL_CONF)
	@cp -n ./src/.env.example ./src/.env || true
	@$(MAKE) --no-print-directory build-php-fpm
	@$(MAKE) --no-print-directory build-nginx
	@rm -rf $(APP_URL_CONF)
	@echo $(call message_success, Run \`make setup\` successfully executed)

up:
	@echo
	@echo $(call message_info, Docker UP Container)
	@echo
	docker compose down && docker compose build --no-cache && docker compose up --force-recreate --no-build --no-deps --detach
	@echo
	@echo $(call message_info, App domain: http://$(APP_URL):$(APP_PORT))
	@echo $(call message_info, Add '127.0.0.1 $(APP_URL)' into your /etc/hosts)
	@echo $(call message_success, Your application is up successfully)

assets-watcher:
	@echo
	@echo $(call message_info, That the assets are rebuilt each time they change)
	@echo
	docker exec -it ${PROJECT_NAME}-app sh -c 'npm run watch'

generate-key:
	@echo
	@echo $(call message_info, Generate app key for project)
	@echo
	docker exec -it ${PROJECT_NAME}-app sh -c 'php artisan key:generate --ansi'
	@$(MAKE) --no-print-directory restart
	@echo $(call message_success, Your application key is generated successfully)
	@echo

exec-app:
	@echo
	@echo $(call message_info, Attach your application)
	@echo
	docker exec -it ${PROJECT_NAME}-app sh

exec-mysql:
	@echo
	@echo $(call message_info, Attach your mysql)
	@echo
	docker exec -it ${PROJECT_NAME}-mysql sh -c 'mysql -u${DB_USERNAME} -p'

exec-nginx:
	@echo
	@echo $(call message_info, Attach your nginx)
	@echo
	docker exec -it ${PROJECT_NAME}-nginx sh

exec-redis:
	@echo
	@echo $(call message_info, Attach your redis)
	@echo
	docker exec -it ${PROJECT_NAME}-redis sh

restart:
	@echo
	@echo $(call message_info, Restart application)
	@echo
	docker compose --project-name '${PROJECT_NAME}' restart
	@echo $(call message_success, Your application is restart successfully)
	@echo

build-php-fpm:
	@echo
	@echo $(call message_info, Docker build $(PHP_FPM_IMAGE) IMAGE)
	@echo
	$(DOCKER_BUILD_EXEC) . -f ./docker/Dockerfile.core -t $(PHP_FPM_IMAGE) --target $(PHP_FPM_TAGET)
	@echo $(call message_success, Docker build $(PHP_FPM_IMAGE) is successfully)

build-nginx:
	@echo
	@echo $(call message_info, Docker build $(NGINX_IMAGE) IMAGE)
	@echo
	$(DOCKER_BUILD_EXEC) . -f ./docker/Dockerfile.core -t $(NGINX_IMAGE) --target $(NGINX_TAGET)
	@echo $(call message_success, Docker build $(NGINX_IMAGE) is successfully)
