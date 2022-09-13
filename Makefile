# Environment variables
# If the following required environment variables are not set,
# we try to get them from the .env file:

ifndef APP_NAME
	APP_NAME=$$(grep '^APP_NAME=' .env | cut -d= -f2-)
endif

ifndef APP_VERSION
	APP_VERSION=$$(grep '^APP_VERSION=' .env | cut -d= -f2-)
endif

# Commands

default: help

.PHONY: venv
venv: ## Creates a virtual environment.
	python3 -m venv venv

.PHONY: requirements
requirements: ## Builds or updates requirements.
	venv/bin/pip install --upgrade pip wheel setuptools pip-tools
	venv/bin/pip-compile --upgrade requirements.in

.PHONY: install
install: ## Installs dependencies.
	venv/bin/pip install --upgrade pip wheel setuptools
	venv/bin/pip install -r requirements.txt

.PHONY: tests
tests: ## Runs all tests.
	venv/bin/tox

.PHONY: clean-dev
clean-dev: clean-python ## Cleans development environment (Docker containers and volumes).
	docker rm ${APP_NAME}_dev_${APP_NAME}_1; exit 0
	rm -rf .tox/*
	rm -rf venv/*

.PHONY: build
build: clean-python ## Builds Docker image.
	docker build \
		--tag ${APP_NAME}:${APP_VERSION} \
		--tag ${APP_NAME}:latest \
		--file Dockerfile \
		.
	@echo "[ OK ] The '${APP_NAME}:${APP_VERSION}' image was build successfully!"

.PHONY: clean-python
clean-python: ## Cleans Python environment.
	find . -path "*.pyc" -delete
	find . -path "*/__pycache__" -delete

.PHONY: dev
dev: clean-python ## Runs app in development mode.
	docker-compose \
		--project-name ${APP_NAME}_dev \
		up \
		--build \
		--remove-orphans \
		--renew-anon-volumes

.PHONY: help
help: ## Lists all the available commands.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
