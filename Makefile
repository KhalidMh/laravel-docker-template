.SILENT:
.PHONY: help ps build build-fresh start stop restart fresh ssh-php ssh-vue ssh-db cache cache-clear migrate npm-install npm-build logs logs-php logs-vue logs-db

.DEFAULT_GOAL := help

help: ## Print help.
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

start: ## Start all containers
	docker compose up --force-recreate -d app

stop: ## Stop and destroy all containers
	docker compose down

restart: stop start ## Restart all containers

ps: ## Show runinng containers.
	docker compose ps

build: ## Build all containers
	docker compose build

build-fresh: stop ## Stop and build all containers from scratch
	docker compose build --no-cache

fresh: stop build start ## Recreate all containers and restart

prune: ## Remove all unused containers, networks, images, volumes.
	docker system prune -a --volumes

prune-volumes: ## Remove all unused volumes
	docker volume prune

prune-images: ## Remove all unused images
	docker image prune -a

php: ## SSH inside PHP container
	docker compose exec -it php sh

vue: ## SSH inside Vue container
	docker compose exec -it vue sh

db: ## SSH inside MySql container
	docker compose exec -it mysql sh

cache-clear: ## Clear all Laravel cache types
	docker compose exec php php artisan cache:clear
	docker compose exec php php artisan view:clear
	docker compose exec php php artisan config:clear
	docker compose exec php php artisan event:clear
	docker compose exec php php artisan route:clear

migrate: ## Run migrations
	docker compose exec php php artisan migrate

npm-install: ## Install dependencies
	docker compose exec vue npm install

npm-build: ## Build assets for production
	docker compose exec vue npm run build

logs: ## Print all docker logs
	docker compose logs -f

logs-php: ## Print PHP container logs
	docker compose logs --follow php

logs-vue: ## Print Vue container logs
	docker compose logs --follow vue

logs-db: ## Print MySql container logs
	docker compose logs --follow mysql

clean-telescope: ## Clean Laravel Telescope data
	docker compose exec php php artisan telescope:prune --hours=0