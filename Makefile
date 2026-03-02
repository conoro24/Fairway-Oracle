API_DIR := ../fairway-oracle-api

.PHONY: db api dev stop-db ingest help

## Start PostgreSQL in Docker (detached, persists data)
db:
	cd $(API_DIR) && docker compose up -d
	@echo "✔ Database running on localhost:5432"

## Stop PostgreSQL Docker container
stop-db:
	cd $(API_DIR) && docker compose stop

## Start Spring Boot backend (requires DB to be running)
api:
	cd $(API_DIR) && SPRING_PROFILES_ACTIVE=local mvn spring-boot:run

## Start Vite frontend dev server
dev:
	npm run dev

## Manually trigger ingestion of completed 2026 tournaments (auto-runs Tuesdays 08:00 UTC)
ingest:
	curl -s -X POST "http://localhost:8080/api/admin/ingest?year=2026" \
		-H "X-Admin-Key: local-admin-key" | cat
	@echo ""

## Show help
help:
	@echo ""
	@echo "Fairway Oracle — dev commands"
	@echo ""
	@echo "  make db        Start PostgreSQL (Docker, detached)"
	@echo "  make stop-db   Stop PostgreSQL container"
	@echo "  make api       Start Spring Boot backend  (localhost:8080)"
	@echo "  make dev       Start Vite frontend         (localhost:5173)"
	@echo "  make ingest    Manually trigger 2026 tournament ingestion"
	@echo ""
	@echo "Typical startup order:"
	@echo "  Terminal 1:  make db"
	@echo "  Terminal 2:  make api"
	@echo "  Terminal 3:  make dev"
	@echo ""
