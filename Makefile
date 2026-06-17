# Makefile for managing PostgreSQL Docker container

# Docker image name
POSTGRES_IMAGE ?= postgres:latest

# Container name
CONTAINER_NAME ?= postgres-db

# PostgreSQL environment variables
POSTGRES_USER ?= postgres
POSTGRES_PASSWORD ?= postgres
POSTGRES_DB ?= postgres

# Port mapping
POSTGRES_PORT ?= 5432:5432

# Data volume - use ./pgdata for local directory, or pgdata for Docker volume
POSTGRES_DATA ?= pgdata

.PHONY: start stop restart status logs shell psql help

# Open PostgreSQL shell via docker exec (inside container)
shell:
	@echo "Connecting to PostgreSQL..."
	@docker exec -it $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

# Connect to PostgreSQL from host machine (requires local psql)
psql:
	@echo "Connecting to PostgreSQL from host..."
	PGPASSWORD=$(POSTGRES_PASSWORD) PSQLRC=.psqlrc psql -h localhost -U $(POSTGRES_USER) -d $(POSTGRES_DB)

# Show help
help:
	@echo "Available commands:"
	@echo "  make start    - Start PostgreSQL container"
	@echo "  make stop     - Stop and remove container"
	@echo "  make restart  - Restart container"
	@echo "  make status   - Show container status"
	@echo "  make logs     - View container logs"
	@echo "  make shell    - Open psql inside container"
	@echo "  make psql     - Connect via psql from host"
	@echo "  make clean    - Stop and remove volume"

# Start PostgreSQL container
start:
	@docker run -d --name $(CONTAINER_NAME) \
		-e POSTGRES_USER=$(POSTGRES_USER) \
		-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
		-e POSTGRES_DB=$(POSTGRES_DB) \
		-p $(POSTGRES_PORT) \
		-v $(POSTGRES_DATA):/var/lib/postgresql \
		$(POSTGRES_IMAGE)
	@echo "PostgreSQL container '$(CONTAINER_NAME)' started on port $(POSTGRES_PORT)"

# Stop PostgreSQL container
stop:
	@echo "Stopping PostgreSQL container..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || echo "Container '$(CONTAINER_NAME)' is not running"
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "PostgreSQL container '$(CONTAINER_NAME)' stopped and removed"

# Restart PostgreSQL container
restart: stop start
	@echo "PostgreSQL container '$(CONTAINER_NAME)' restarted"

# Check container status
status:
	@docker ps -a --filter "name=$(CONTAINER_NAME)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# View container logs
logs:
	docker logs $(CONTAINER_NAME)

# Follow container logs
logs-follow:
	docker logs -f $(CONTAINER_NAME)

# Stop and remove container, then remove volume
clean: stop
	@echo "Removing PostgreSQL data volume..."
	@docker volume rm $(POSTGRES_DATA) 2>/dev/null || echo "Volume '$(POSTGRES_DATA)' not found or already removed"
	@echo "Cleanup complete"
