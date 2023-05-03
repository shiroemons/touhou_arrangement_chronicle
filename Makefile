.PHONY: help init build-local db-up up down logs ps migrate seeder importer all-clean test lint
.DEFAULT_GOAL := help

init: ## Initialize environment
	docker compose build

build-local: ## Build docker image to local development
	docker compose build --no-cache

up: ## Do docker compose up with hot reload
	docker compose up -d

db-up: ## Run docker compose up db
	docker compose up db -d

down: ## Do docker compose down
	docker compose down

logs: ## Tail docker compose logs
	docker compose logs -f

ps: ## Check container status
	docker compose ps

db-setup: ## db setup
	cat db/schema/xid.sql | psql -h localhost -p 15432 -U postgres touhou_arrangement_chronicle_development

migrate: ## db migrate
	docker compose run --rm migrate

seeder: ## db seed
	docker compose run --rm seeder

indexer: ## indexer
	docker compose run --rm indexer

importer: ## importer
	docker compose run --rm importer

all-clean:
	docker compose down --rmi all --volumes --remove-orphans

test: ## Execute tests
	go test -race -shuffle=on ./...

lint:
	docker run --rm -v $(shell pwd):/app -w /app golangci/golangci-lint:latest golangci-lint run -v --timeout 5m

server: ## Run server
	docker compose run --rm --service-ports web

console: ## Run console
	docker compose run --rm web bin/rails console

console-sandbox: ## Run console(sandbox)
	docker compose run --rm web bin/rails console --sandbox

bundle: ## Run bundle install
	docker compose run --rm web bundle config set clean true
	docker compose run --rm web bundle install --jobs=4

bash: ## Run bash in web container
	docker compose run --rm web bash

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
