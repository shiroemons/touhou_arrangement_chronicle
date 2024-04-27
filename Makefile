.PHONY: help init build-local db-up up down logs ps setup migrate seeder importer all-clean test generate lint server console console-sandbox bundle bash rubocop rubocop-a rubocop-all
.DEFAULT_GOAL := help

init: ## Initialize environment
	docker compose build

build-local: ## Build docker image to local development
	docker compose build --no-cache

up: ## Do docker compose up with hot reload
	docker compose up -d

db-up: ## Run docker compose up db
	docker compose up postgres16 -d

down: ## Do docker compose down
	docker compose down

logs: ## Tail docker compose logs
	docker compose logs -f $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

ps: ## Check container status
	docker compose ps

setup:
	docker compose run --rm admin bundle config set clean true
	docker compose run --rm admin bundle install --jobs=4
	docker compose up -d postgres16
	sleep 5
	docker compose exec postgres16 psql -h localhost -p 5432 -U postgres touhou_arrangement_chronicle_development -f /tmp/db/schema/cuid.sql
	docker compose run --rm migrate
	docker compose run --rm seeder
	docker compose run --rm admin bin/rails db:seed

db-reset: ## db reset
	docker compose down
	docker volume rm touhou_arrangement_chronicle_postgres
	docker compose up -d postgres16
	sleep 5
	docker compose exec postgres16 psql -h localhost -p 5432 -U postgres touhou_arrangement_chronicle_development -f /tmp/db/schema/cuid.sql
	docker compose run --rm migrate
	docker compose run --rm seeder
	docker compose run --rm admin bin/rails db:seed

migrate: ## db migrate
	docker compose run --rm migrate

seeder: ## db seed
	docker compose run --rm seeder
	docker compose run --rm admin bin/rails db:seed

indexer: ## indexer
	docker compose run --rm indexer

importer: ## importer
	docker compose run --rm importer

all-clean:
	docker compose down --rmi all --volumes --remove-orphans

test: ## Execute tests
	go test -race -shuffle=on ./...

generate: ## Run go generate ./...
	go generate ./...

lint:
	docker run --rm -v $(shell pwd):/app -w /app golangci/golangci-lint:latest golangci-lint run -v --timeout 5m

server: ## Run server
	docker compose run --rm --service-ports admin

console: ## Run console
	docker compose run --rm admin bin/rails console

console-sandbox: ## Run console(sandbox)
	docker compose run --rm admin bin/rails console --sandbox

bundle: ## Run bundle install
	docker compose run --rm admin bundle config set clean true
	docker compose run --rm admin bundle install --jobs=4

bash-admin: ## Run bash in admin container
	docker compose run --rm admin bash

bash-frontend: ## Run bash in frontend container
	docker compose run --rm frontend bash

rubocop: ## Run rubocop
	docker compose run --rm admin bundle exec rubocop

rubocop-a: ## Run rubocop (auto correct)
	docker compose run --rm admin bundle exec rubocop -a

rubocop-all: ## Run rubocop (auto correct all)
	docker compose run --rm admin bundle exec rubocop -A

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
