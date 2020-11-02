.DEFAULT_GOAL:=help

COMPOSE_FILES_PATH := -f docker-compose.yml

.PHONY: build up up-detach down nuke restart ssh help

build: ## This builds the images
	docker-compose $(COMPOSE_FILES_PATH) build

up: ## This brings up the app
	docker-compose $(COMPOSE_FILES_PATH) up

up-build: ## This brings up the app with a build
	docker-compose $(COMPOSE_FILES_PATH) up --build

up-detach: ## This brings up the app and detaches the shell from the logs
	docker-compose $(COMPOSE_FILES_PATH) up -d

down: ## This takes down the app
	docker-compose $(COMPOSE_FILES_PATH) down

nuke: ## This removes all the volumes as well as taking down the app
	docker-compose $(COMPOSE_FILES_PATH) down -v

restart: down up ## This restarts the app

hard-restart: down up-build ## This restarts the app with a build

ssh: ## This docker execs you in to the web container
	docker-compose exec opendsa-lti bash

ssh-db: ## This docker execs you into the mysql database
	docker-compose exec db mysql -uroot -p'opendsa'

logs: ## This attachs you to the logs if you ran in detached mode
	docker logs -f opendsa-lti_opendsa-lti_1

help: ## This is the help dialog
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m \n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
