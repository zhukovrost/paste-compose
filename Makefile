# Include variables from the .envrc file
include .env

# ==================================================================================== #
# RUN
# ==================================================================================== #

## run/api: run the application
.PHONY: run/api
run/api: # dev/services/stop
	@echo 'Running app...'
	docker compose up

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## dev/services/start runs all services locally
.PHONY: dev/services/start
dev/services/start:
	sudo systemctl start redis
	sudo systemctl start postgresql
	sudo systemctl start rabbitmq-server

## dev/services/stop stops all local services
.PHONY: dev/services/stop
dev/services/stop:
	sudo systemctl stop redis
	sudo systemctl stop postgresql
	sudo systemctl stop rabbitmq-server

## db/psql: connect to the database using psql (development only)
.PHONY: db/psql
db/psql:
	docker exec -it paste-compose-postgres-1 psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}

## db/migrations/new name=$1: create a new database migration (development only)
.PHONY: db/migrations/new
db/migrations/up:
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${PASTE_DB_DSN} up
