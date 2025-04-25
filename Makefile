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

console:
	docker compose run --rm admin bin/rails console

console-sandbox:
	docker compose run --rm admin bin/rails console --sandbox

import-albums:
	docker compose run --rm admin bin/rails import:albums

reindex-songs:
	docker compose run --rm admin bin/rails meilisearch:reindex_songs

update-meilisearch:
	docker compose pull meilisearch
	docker compose up -d meilisearch

meilisearch-create-dump:
	docker compose exec meilisearch curl -X POST 'http://localhost:7700/dumps' -H 'Authorization: Bearer ${MEILI_MASTER_KEY:-masterKey}'

meilisearch-upgrade-dumpless:
	docker compose down meilisearch
	docker compose run --rm -e MEILI_MASTER_KEY=${MEILI_MASTER_KEY:-masterKey} meilisearch meilisearch --experimental-dumpless-upgrade
	docker compose up -d meilisearch

meilisearch-reset:
	docker compose down meilisearch
	docker volume rm touhou_arrangement_chronicle_meilisearch_data
	docker compose up -d meilisearch
	docker compose run --rm admin bin/rails meilisearch:reindex_songs

drizzle-introspect:
	docker compose run --rm frontend npm run drizzle:introspect
	sed -i '' 's/default(gen_random_uuid())/default(sql`gen_random_uuid()`)/g' frontend/drizzle/schema.ts

drizzle-pull:
	docker compose run --rm frontend npm run drizzle:pull
	sed -i '' 's/default(gen_random_uuid())/default(sql`gen_random_uuid()`)/g' frontend/drizzle/schema.ts

drizzle-fix-schema:
	sed -i '' 's/default(gen_random_uuid())/default(sql`gen_random_uuid()`)/g' frontend/drizzle/schema.ts

db-reset:
	docker compose down
	docker compose run --rm dbmate drop
	docker compose run --rm dbmate -e TEST_DATABASE_URL --no-dump-schema drop
	docker compose run --rm dbmate up
	docker compose run --rm dbmate -e TEST_DATABASE_URL --no-dump-schema up
	docker compose up -d
	docker compose run --rm admin bin/rails db:migrate
	docker compose run --rm admin bin/rails db:seed

db-seed:
	docker compose run --rm admin bin/rails db:seed
