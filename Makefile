up:
	docker compose up -d

down:
	docker compose down

migrate:
	docker compose run --rm dbmate up
	docker compose run --rm dbmate -e TEST_DATABASE_URL --no-dump-schema up

drop:
	docker compose run --rm dbmate drop
	docker compose run --rm dbmate -e TEST_DATABASE_URL --no-dump-schema drop

rollback:
	docker compose run --rm dbmate down

dbmate-new:
	docker compose run --rm dbmate new "$(filter-out $@,$(MAKECMDGOALS))"

dbmate-status:
	docker compose run --rm dbmate status

logs:
	docker compose logs -f $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

ps:
	docker compose ps

bundle:
	docker compose run --rm admin bundle install --jobs=4

bash-admin:
	docker compose run --rm admin bash

rubocop:
	docker compose run --rm admin bundle exec rubocop

rubocop-autocorrect:
	docker compose run --rm admin bundle exec rubocop -a

test:
	docker compose run --rm admin bundle exec rails test

seed:
	docker compose run --rm admin bundle exec rails db:seed