up:
	docker compose up -d

down:
	docker compose down

migrate:
	docker compose run --rm dbmate up
	docker compose run --rm dbmate -e TEST_DATABASE_URL --no-dump-schema up

rollback:
	docker compose run --rm dbmate down

dbmate-new:
	docker compose run --rm dbmate new "$(filter-out $@,$(MAKECMDGOALS))"

dbmate-status:
	docker compose run --rm dbmate status

%:
	@: