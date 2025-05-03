import { pgTable, varchar, index, text, timestamp, numeric, foreignKey, integer, boolean, unique, uuid, jsonb, uniqueIndex, check, date, bigint, pgEnum } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"

export const first_character_type = pgEnum("first_character_type", ['symbol', 'number', 'alphabet', 'hiragana', 'katakana', 'kanji', 'other'])
export const product_type = pgEnum("product_type", ['pc98', 'windows', 'zuns_music_collection', 'akyus_untouched_score', 'commercial_books', 'tasofro', 'other'])


export const schema_migrations = pgTable("schema_migrations", {
	version: varchar({ length: 128 }).primaryKey().notNull(),
});

export const products = pgTable("products", {
	id: text().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	name_reading: text(),
	short_name: text().notNull(),
	product_type: product_type().notNull(),
	series_number: numeric({ precision: 5, scale:  2 }).notNull(),
}, (table) => [
	index("idx_products_product_type").using("btree", table.product_type.asc().nullsLast().op("enum_ops")),
	index("idx_products_series_number").using("btree", table.series_number.asc().nullsLast().op("numeric_ops")),
]);

export const original_songs = pgTable("original_songs", {
	id: text().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	product_id: text().notNull(),
	name: text().notNull(),
	name_reading: text(),
	composer: text(),
	arranger: text(),
	track_number: integer().notNull(),
	is_original: boolean().default(false).notNull(),
	origin_original_song_id: text(),
}, (table) => [
	index("idx_original_songs_is_original").using("btree", table.is_original.asc().nullsLast().op("bool_ops")),
	index("idx_original_songs_origin_original_song_id").using("btree", table.origin_original_song_id.asc().nullsLast().op("text_ops")),
	index("idx_original_songs_product_id").using("btree", table.product_id.asc().nullsLast().op("text_ops")),
	index("idx_original_songs_product_original").using("btree", table.product_id.asc().nullsLast().op("text_ops"), table.is_original.asc().nullsLast().op("bool_ops")),
	index("idx_original_songs_track_number").using("btree", table.track_number.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.product_id],
			foreignColumns: [products.id],
			name: "original_songs_product_id_fkey"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.origin_original_song_id],
			foreignColumns: [table.id],
			name: "original_songs_origin_original_song_id_fkey"
		}).onDelete("set null"),
]);

export const distribution_services = pgTable("distribution_services", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	service_name: text().notNull(),
	display_name: text().notNull(),
	base_urls: jsonb().notNull(),
	description: text(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_distribution_services_base_urls").using("gin", table.base_urls.asc().nullsLast().op("jsonb_ops")),
	index("idx_distribution_services_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	unique("distribution_services_service_name_key").on(table.service_name),
]);

export const streamable_urls = pgTable("streamable_urls", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	streamable_type: text().notNull(),
	streamable_id: text().notNull(),
	service_name: text().notNull(),
	url: text().notNull(),
	description: text(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_streamable_urls_service_name").using("btree", table.service_name.asc().nullsLast().op("text_ops")),
	index("idx_streamable_urls_type_service").using("btree", table.streamable_type.asc().nullsLast().op("text_ops"), table.service_name.asc().nullsLast().op("text_ops")),
	uniqueIndex("uk_streamable_urls_streamable_id_service").using("btree", table.streamable_type.asc().nullsLast().op("text_ops"), table.streamable_id.asc().nullsLast().op("text_ops"), table.service_name.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.service_name],
			foreignColumns: [distribution_services.service_name],
			name: "streamable_urls_service_name_fkey"
		}).onDelete("restrict"),
	check("streamable_urls_streamable_type_check", sql`streamable_type = ANY (ARRAY['Product'::text, 'OriginalSong'::text, 'Album'::text, 'Song'::text])`),
]);

export const event_series = pgTable("event_series", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	display_name: text().notNull(),
	display_name_reading: text(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_event_series_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_event_series_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_event_series_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	unique("event_series_name_key").on(table.name),
	unique("event_series_slug_key").on(table.slug),
]);

export const event_editions = pgTable("event_editions", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	event_series_id: uuid().notNull(),
	name: text().notNull(),
	display_name: text().notNull(),
	display_name_reading: text(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	start_date: date(),
	end_date: date(),
	touhou_date: date(),
	description: text(),
	note: text(),
	url: text(),
	twitter_url: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_event_editions_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_event_editions_end_date").using("btree", table.end_date.asc().nullsLast().op("date_ops")),
	index("idx_event_editions_event_series_id").using("btree", table.event_series_id.asc().nullsLast().op("uuid_ops")),
	index("idx_event_editions_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_event_editions_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_event_editions_start_date").using("btree", table.start_date.asc().nullsLast().op("date_ops")),
	index("idx_event_editions_touhou_date").using("btree", table.touhou_date.asc().nullsLast().op("date_ops")),
	uniqueIndex("uk_event_editions_event_series_id_name").using("btree", table.event_series_id.asc().nullsLast().op("uuid_ops"), table.name.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.event_series_id],
			foreignColumns: [event_series.id],
			name: "event_editions_event_series_id_fkey"
		}).onDelete("restrict"),
	unique("event_editions_slug_key").on(table.slug),
]);

export const event_days = pgTable("event_days", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	event_edition_id: uuid().notNull(),
	day_number: integer(),
	display_name: text(),
	event_date: date(),
	region_code: text().default('JP').notNull(),
	is_cancelled: boolean().default(false).notNull(),
	is_online: boolean().default(false).notNull(),
	description: text(),
	note: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_event_days_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_event_days_comprehensive").using("btree", table.event_edition_id.asc().nullsLast().op("date_ops"), table.event_date.asc().nullsLast().op("uuid_ops"), table.is_cancelled.asc().nullsLast().op("uuid_ops"), table.is_online.asc().nullsLast().op("uuid_ops")),
	index("idx_event_days_event_date").using("btree", table.event_date.asc().nullsLast().op("date_ops")),
	index("idx_event_days_event_edition_id").using("btree", table.event_edition_id.asc().nullsLast().op("uuid_ops")),
	index("idx_event_days_is_cancelled").using("btree", table.is_cancelled.asc().nullsLast().op("bool_ops")),
	index("idx_event_days_is_online").using("btree", table.is_online.asc().nullsLast().op("bool_ops")),
	index("idx_event_days_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_event_days_region_code").using("btree", table.region_code.asc().nullsLast().op("text_ops")),
	uniqueIndex("uk_event_days_event_edition_id_day_number_is_online").using("btree", table.event_edition_id.asc().nullsLast().op("int4_ops"), table.day_number.asc().nullsLast().op("int4_ops"), table.is_online.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.event_edition_id],
			foreignColumns: [event_editions.id],
			name: "event_days_event_edition_id_fkey"
		}).onDelete("cascade"),
]);

export const artists = pgTable("artists", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	note: text(),
}, (table) => [
	uniqueIndex("uk_artists_name").using("btree", table.name.asc().nullsLast().op("text_ops")),
]);

export const artist_names = pgTable("artist_names", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	artist_id: uuid().notNull(),
	name: text().notNull(),
	name_reading: text(),
	is_main_name: boolean().default(false).notNull(),
	first_character_type: first_character_type().notNull(),
	first_character: text(),
	first_character_row: text(),
	description: text(),
	note: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
}, (table) => [
	index("idx_artist_names_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_artist_names_artist_id").using("btree", table.artist_id.asc().nullsLast().op("uuid_ops")),
	index("idx_artist_names_comprehensive").using("btree", table.first_character_type.asc().nullsLast().op("text_ops"), table.first_character.asc().nullsLast().op("text_ops"), table.first_character_row.asc().nullsLast().op("enum_ops")),
	index("idx_artist_names_first_character").using("btree", table.first_character_type.asc().nullsLast().op("enum_ops"), table.first_character.asc().nullsLast().op("text_ops")),
	index("idx_artist_names_first_character_type").using("btree", table.first_character_type.asc().nullsLast().op("enum_ops")),
	index("idx_artist_names_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	uniqueIndex("uk_artist_names_artist_id_main_name").using("btree", table.artist_id.asc().nullsLast().op("uuid_ops"), table.is_main_name.asc().nullsLast().op("uuid_ops")).where(sql`(is_main_name = true)`),
	foreignKey({
			columns: [table.artist_id],
			foreignColumns: [artists.id],
			name: "artist_names_artist_id_fkey"
		}).onDelete("cascade"),
	check("artist_names_check", sql`((first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NULL))`),
	check("artist_names_check1", sql`((first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NULL))`),
]);

export const reference_urls = pgTable("reference_urls", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	referenceable_type: text().notNull(),
	referenceable_id: uuid().notNull(),
	url_type: text().notNull(),
	url: text().notNull(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_reference_urls_referenceable").using("btree", table.referenceable_type.asc().nullsLast().op("text_ops"), table.referenceable_id.asc().nullsLast().op("uuid_ops")),
	index("idx_reference_urls_url_type").using("btree", table.url_type.asc().nullsLast().op("text_ops")),
	uniqueIndex("uk_reference_urls_referenceable_type_referenceable_id_url").using("btree", table.referenceable_type.asc().nullsLast().op("uuid_ops"), table.referenceable_id.asc().nullsLast().op("uuid_ops"), table.url.asc().nullsLast().op("uuid_ops")),
	check("reference_urls_referenceable_type_check", sql`referenceable_type = ANY (ARRAY['ArtistName'::text, 'Album'::text, 'Circle'::text, 'Song'::text])`),
]);

export const circles = pgTable("circles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	name_reading: text(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	first_character_type: first_character_type().notNull(),
	first_character: text(),
	first_character_row: text(),
	description: text(),
	note: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
}, (table) => [
	index("idx_circles_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_circles_comprehensive").using("btree", table.first_character_type.asc().nullsLast().op("enum_ops"), table.first_character.asc().nullsLast().op("enum_ops"), table.first_character_row.asc().nullsLast().op("enum_ops")),
	index("idx_circles_first_character").using("btree", table.first_character_type.asc().nullsLast().op("text_ops"), table.first_character.asc().nullsLast().op("enum_ops")),
	index("idx_circles_first_character_type").using("btree", table.first_character_type.asc().nullsLast().op("enum_ops")),
	index("idx_circles_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	uniqueIndex("uk_circles_name").using("btree", table.name.asc().nullsLast().op("text_ops")),
	unique("circles_slug_key").on(table.slug),
	check("circles_check", sql`((first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NULL))`),
	check("circles_check1", sql`((first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NULL))`),
]);

export const albums = pgTable("albums", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	name_reading: text(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	release_circle_id: uuid(),
	release_circle_name: text(),
	release_date: date(),
	release_year: integer(),
	release_month: integer(),
	event_day_id: uuid(),
	album_number: text(),
	credit: text(),
	introduction: text(),
	description: text(),
	note: text(),
	url: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_albums_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_albums_comprehensive_release").using("btree", table.release_year.asc().nullsLast().op("int4_ops"), table.release_month.asc().nullsLast().op("date_ops"), table.release_date.asc().nullsLast().op("int4_ops")),
	index("idx_albums_event_day_id").using("btree", table.event_day_id.asc().nullsLast().op("uuid_ops")),
	index("idx_albums_publication_status").using("btree", sql`COALESCE(published_at, '1970-01-01 00:00:00+00'::timestamp with`, sql`COALESCE(archived_at, '9999-12-31 00:00:00+00'::timestamp with `),
	index("idx_albums_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_albums_release_circle_id").using("btree", table.release_circle_id.asc().nullsLast().op("uuid_ops")),
	index("idx_albums_release_date").using("btree", table.release_date.asc().nullsLast().op("date_ops")),
	index("idx_albums_release_month").using("btree", table.release_month.asc().nullsLast().op("int4_ops")),
	index("idx_albums_release_year").using("btree", table.release_year.asc().nullsLast().op("int4_ops")),
	index("idx_albums_release_year_month").using("btree", table.release_year.asc().nullsLast().op("int4_ops"), table.release_month.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.release_circle_id],
			foreignColumns: [circles.id],
			name: "albums_release_circle_id_fkey"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.event_day_id],
			foreignColumns: [event_days.id],
			name: "albums_event_day_id_fkey"
		}).onDelete("set null"),
	unique("albums_slug_key").on(table.slug),
]);

export const albums_circles = pgTable("albums_circles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	album_id: uuid().notNull(),
	circle_id: uuid().notNull(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_albums_circles_album_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops")),
	index("idx_albums_circles_circle_id").using("btree", table.circle_id.asc().nullsLast().op("uuid_ops")),
	index("idx_albums_circles_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	uniqueIndex("uk_albums_circles_album_id_circle_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops"), table.circle_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.album_id],
			foreignColumns: [albums.id],
			name: "albums_circles_album_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.circle_id],
			foreignColumns: [circles.id],
			name: "albums_circles_circle_id_fkey"
		}).onDelete("cascade"),
]);

export const album_prices = pgTable("album_prices", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	album_id: uuid().notNull(),
	price_type: text().notNull(),
	is_free: boolean().default(false).notNull(),
	price: numeric().notNull(),
	currency: text().default('JPY').notNull(),
	tax_included: boolean().default(false).notNull(),
	shop_id: uuid(),
	url: text(),
	description: text(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_album_prices_album_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops")),
	index("idx_album_prices_album_id_price_type").using("btree", table.album_id.asc().nullsLast().op("text_ops"), table.price_type.asc().nullsLast().op("uuid_ops")),
	index("idx_album_prices_combined").using("btree", table.price_type.asc().nullsLast().op("bool_ops"), table.is_free.asc().nullsLast().op("text_ops"), table.currency.asc().nullsLast().op("bool_ops")),
	index("idx_album_prices_price_type").using("btree", table.price_type.asc().nullsLast().op("text_ops")),
	index("idx_album_prices_shop_id").using("btree", table.shop_id.asc().nullsLast().op("uuid_ops")),
	index("idx_album_prices_shop_id_price_type").using("btree", table.shop_id.asc().nullsLast().op("uuid_ops"), table.price_type.asc().nullsLast().op("uuid_ops")),
	uniqueIndex("uk_ap_album_id_shop_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops"), table.shop_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.album_id],
			foreignColumns: [albums.id],
			name: "album_prices_album_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.shop_id],
			foreignColumns: [shops.id],
			name: "album_prices_shop_id_fkey"
		}).onDelete("restrict"),
	check("album_prices_price_type_check", sql`price_type = ANY (ARRAY['event'::text, 'shop'::text])`),
	check("album_prices_check", sql`((is_free = true) AND (price = (0)::numeric)) OR ((is_free = false) AND (price > (0)::numeric))`),
]);

export const shops = pgTable("shops", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	display_name: text().notNull(),
	description: text(),
	note: text(),
	website_url: text(),
	base_urls: jsonb(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_shops_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_shops_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_shops_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	unique("shops_name_key").on(table.name),
]);

export const album_upcs = pgTable("album_upcs", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	album_id: uuid().notNull(),
	upc: text().notNull(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_album_upcs_album_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops")),
	index("idx_album_upcs_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	uniqueIndex("uk_album_upcs_album_id_upc").using("btree", table.album_id.asc().nullsLast().op("uuid_ops"), table.upc.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.album_id],
			foreignColumns: [albums.id],
			name: "album_upcs_album_id_fkey"
		}).onDelete("cascade"),
]);

export const album_discs = pgTable("album_discs", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	album_id: uuid().notNull(),
	disc_number: integer(),
	name: text(),
	description: text(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_album_discs_album_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops")),
	index("idx_album_discs_disc_number").using("btree", table.disc_number.asc().nullsLast().op("int4_ops")),
	index("idx_album_discs_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.album_id],
			foreignColumns: [albums.id],
			name: "album_discs_album_id_fkey"
		}).onDelete("cascade"),
]);

export const songs = pgTable("songs", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	circle_id: uuid(),
	album_id: uuid(),
	name: text().notNull(),
	name_reading: text(),
	release_date: date(),
	release_year: integer(),
	release_month: integer(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	album_disc_id: uuid(),
	disc_number: integer(),
	track_number: integer(),
	length_time_ms: integer(),
	bpm: integer(),
	description: text(),
	note: text(),
	display_composer: text(),
	display_arranger: text(),
	display_rearranger: text(),
	display_lyricist: text(),
	display_vocalist: text(),
	display_original_song: text(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }),
	archived_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_songs_album_id").using("btree", table.album_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_album_track").using("btree", table.album_id.asc().nullsLast().op("int4_ops"), table.track_number.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_archived_at").using("btree", table.archived_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_songs_circle_id").using("btree", table.circle_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_comprehensive_release").using("btree", table.release_year.asc().nullsLast().op("int4_ops"), table.release_month.asc().nullsLast().op("int4_ops"), table.release_date.asc().nullsLast().op("int4_ops")),
	index("idx_songs_disc_tracking").using("btree", table.album_id.asc().nullsLast().op("int4_ops"), table.disc_number.asc().nullsLast().op("int4_ops"), table.track_number.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_songs_release_date").using("btree", table.release_date.asc().nullsLast().op("date_ops")),
	index("idx_songs_release_month").using("btree", table.release_month.asc().nullsLast().op("int4_ops")),
	index("idx_songs_release_year").using("btree", table.release_year.asc().nullsLast().op("int4_ops")),
	index("idx_songs_release_year_month").using("btree", table.release_year.asc().nullsLast().op("int4_ops"), table.release_month.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.circle_id],
			foreignColumns: [circles.id],
			name: "songs_circle_id_fkey"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.album_id],
			foreignColumns: [albums.id],
			name: "songs_album_id_fkey"
		}).onDelete("restrict"),
	foreignKey({
			columns: [table.album_disc_id],
			foreignColumns: [album_discs.id],
			name: "songs_album_disc_id_fkey"
		}).onDelete("set null"),
	unique("songs_slug_key").on(table.slug),
]);

export const song_lyrics = pgTable("song_lyrics", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	content: text().notNull(),
	language: text().default('ja'),
	description: text(),
	note: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_song_lyrics_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_song_lyrics_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "song_lyrics_song_id_fkey"
		}).onDelete("cascade"),
]);

export const song_bmps = pgTable("song_bmps", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	bpm: integer().notNull(),
	// You can use { mode: "bigint" } if numbers are exceeding js number limitations
	start_time_ms: bigint({ mode: "number" }),
	// You can use { mode: "bigint" } if numbers are exceeding js number limitations
	end_time_ms: bigint({ mode: "number" }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_song_bmps_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_song_bmps_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "song_bmps_song_id_fkey"
		}).onDelete("cascade"),
]);

export const song_isrcs = pgTable("song_isrcs", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	isrc: text().notNull(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_song_isrcs_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_song_isrcs_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	uniqueIndex("uk_song_isrcs_song_id_isrc").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.isrc.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "song_isrcs_song_id_fkey"
		}).onDelete("cascade"),
]);

export const songs_arrange_circles = pgTable("songs_arrange_circles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	circle_id: uuid().notNull(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_songs_arrange_circles_circle_id").using("btree", table.circle_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_arrange_circles_combined").using("btree", table.circle_id.asc().nullsLast().op("int4_ops"), table.song_id.asc().nullsLast().op("uuid_ops"), table.position.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_arrange_circles_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	uniqueIndex("uk_songs_arrange_circles_song_id_circle_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.circle_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "songs_arrange_circles_song_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.circle_id],
			foreignColumns: [circles.id],
			name: "songs_arrange_circles_circle_id_fkey"
		}).onDelete("cascade"),
]);

export const songs_original_songs = pgTable("songs_original_songs", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	original_song_id: text().notNull(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_songs_original_songs_original_song_id").using("btree", table.original_song_id.asc().nullsLast().op("text_ops")),
	index("idx_songs_original_songs_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_songs_original_songs_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	uniqueIndex("uk_songs_original_songs_song_id_original_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.original_song_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "songs_original_songs_song_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.original_song_id],
			foreignColumns: [original_songs.id],
			name: "songs_original_songs_original_song_id_fkey"
		}).onDelete("cascade"),
]);

export const songs_artist_roles = pgTable("songs_artist_roles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	artist_name_id: uuid().notNull(),
	artist_role_id: uuid().notNull(),
	connector: text(),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_songs_artist_roles_artist_name_id").using("btree", table.artist_name_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_artist_roles_artist_role_id").using("btree", table.artist_role_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_artist_roles_combined").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.artist_role_id.asc().nullsLast().op("uuid_ops"), table.position.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_artist_roles_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	uniqueIndex("uk_sar_song_id_artist_name_id_artist_role_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.artist_name_id.asc().nullsLast().op("uuid_ops"), table.artist_role_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "songs_artist_roles_song_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.artist_name_id],
			foreignColumns: [artist_names.id],
			name: "songs_artist_roles_artist_name_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.artist_role_id],
			foreignColumns: [artist_roles.id],
			name: "songs_artist_roles_artist_role_id_fkey"
		}).onDelete("cascade"),
]);

export const artist_roles = pgTable("artist_roles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	display_name: text().notNull(),
	description: text(),
	note: text(),
}, (table) => [
	unique("artist_roles_name_key").on(table.name),
]);

export const songs_genres = pgTable("songs_genres", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	song_id: uuid().notNull(),
	genre_id: uuid().notNull(),
	// You can use { mode: "bigint" } if numbers are exceeding js number limitations
	start_time_ms: bigint({ mode: "number" }),
	// You can use { mode: "bigint" } if numbers are exceeding js number limitations
	end_time_ms: bigint({ mode: "number" }),
	locked_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_songs_genres_genre_id").using("btree", table.genre_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_genres_locked_at").using("btree", table.locked_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_songs_genres_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	index("idx_songs_genres_song_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops")),
	index("idx_songs_genres_song_id_genre_id").using("btree", table.song_id.asc().nullsLast().op("uuid_ops"), table.genre_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.song_id],
			foreignColumns: [songs.id],
			name: "songs_genres_song_id_fkey"
		}).onDelete("cascade"),
	foreignKey({
			columns: [table.genre_id],
			foreignColumns: [genres.id],
			name: "songs_genres_genre_id_fkey"
		}).onDelete("cascade"),
]);

export const genres = pgTable("genres", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	description: text(),
	note: text(),
}, (table) => [
	unique("genres_name_key").on(table.name),
]);

export const genreable_genres = pgTable("genreable_genres", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	genreable_type: text().notNull(),
	genreable_id: uuid().notNull(),
	genre_id: uuid().notNull(),
	locked_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_genreable_genres_locked_at").using("btree", table.locked_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_genreable_genres_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	uniqueIndex("uk_genreable_genres_genreable_type_genreable_id_genre_id").using("btree", table.genreable_type.asc().nullsLast().op("uuid_ops"), table.genreable_id.asc().nullsLast().op("text_ops"), table.genre_id.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.genre_id],
			foreignColumns: [genres.id],
			name: "genreable_genres_genre_id_fkey"
		}).onDelete("cascade"),
	check("genreable_genres_genreable_type_check", sql`genreable_type = ANY (ARRAY['Album'::text, 'Circle'::text, 'ArtistName'::text])`),
]);

export const tags = pgTable("tags", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	name: text().notNull(),
	description: text(),
	note: text(),
}, (table) => [
	unique("tags_name_key").on(table.name),
]);

export const taggings = pgTable("taggings", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	taggable_type: text().notNull(),
	taggable_id: uuid().notNull(),
	tag_id: uuid().notNull(),
	locked_at: timestamp({ withTimezone: true, mode: 'string' }),
	position: integer().default(1).notNull(),
}, (table) => [
	index("idx_taggings_locked_at").using("btree", table.locked_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_taggings_position").using("btree", table.position.asc().nullsLast().op("int4_ops")),
	uniqueIndex("uk_taggings_taggable").using("btree", table.taggable_type.asc().nullsLast().op("uuid_ops"), table.taggable_id.asc().nullsLast().op("text_ops"), table.tag_id.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.tag_id],
			foreignColumns: [tags.id],
			name: "taggings_tag_id_fkey"
		}).onDelete("cascade"),
	check("taggings_taggable_type_check", sql`taggable_type = ANY (ARRAY['Album'::text, 'Song'::text, 'Circle'::text, 'ArtistName'::text])`),
]);

export const news = pgTable("news", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	title: text().notNull(),
	content: text().notNull(),
	summary: text(),
	slug: text().default(sql`gen_random_uuid()`).notNull(),
	published_at: timestamp({ withTimezone: true, mode: 'string' }).notNull(),
	expired_at: timestamp({ withTimezone: true, mode: 'string' }),
	is_important: boolean().default(false).notNull(),
	category: text(),
}, (table) => [
	index("idx_news_category").using("btree", table.category.asc().nullsLast().op("text_ops")),
	index("idx_news_expired_at").using("btree", table.expired_at.asc().nullsLast().op("timestamptz_ops")),
	index("idx_news_is_important").using("btree", table.is_important.asc().nullsLast().op("bool_ops")),
	index("idx_news_publication_status").using("btree", sql`published_at`, sql`COALESCE(expired_at, '9999-12-31 00:00:00+00'::timestamp with t`),
	index("idx_news_published_at").using("btree", table.published_at.asc().nullsLast().op("timestamptz_ops")),
	unique("news_slug_key").on(table.slug),
]);

export const ar_internal_metadata = pgTable("ar_internal_metadata", {
	key: varchar().primaryKey().notNull(),
	value: varchar(),
	created_at: timestamp({ precision: 6, mode: 'string' }).notNull(),
	updated_at: timestamp({ precision: 6, mode: 'string' }).notNull(),
});

export const users = pgTable("users", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
});

export const user_authentications = pgTable("user_authentications", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	user_id: uuid().notNull(),
	auth0_user_id: text().notNull(),
	last_login_at: timestamp({ withTimezone: true, mode: 'string' }),
}, (table) => [
	index("idx_user_authentications_auth0_user_id").using("btree", table.auth0_user_id.asc().nullsLast().op("text_ops")),
	index("idx_user_authentications_user_id").using("btree", table.user_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.user_id],
			foreignColumns: [users.id],
			name: "user_authentications_user_id_fkey"
		}).onDelete("cascade"),
	unique("user_authentications_user_id_key").on(table.user_id),
	unique("user_authentications_auth0_user_id_key").on(table.auth0_user_id),
]);

export const user_profiles = pgTable("user_profiles", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	user_id: uuid().notNull(),
	username: text().notNull(),
	display_name: text().notNull(),
	bio: text(),
	avatar_url: text(),
}, (table) => [
	index("idx_user_profiles_user_id").using("btree", table.user_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.user_id],
			foreignColumns: [users.id],
			name: "user_profiles_user_id_fkey"
		}).onDelete("cascade"),
	unique("user_profiles_user_id_key").on(table.user_id),
	unique("user_profiles_username_key").on(table.username),
]);

export const user_settings = pgTable("user_settings", {
	id: uuid().defaultRandom().primaryKey().notNull(),
	created_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updated_at: timestamp({ withTimezone: true, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	user_id: uuid().notNull(),
	is_public_profile: boolean().default(false).notNull(),
}, (table) => [
	index("idx_user_settings_user_id").using("btree", table.user_id.asc().nullsLast().op("uuid_ops")),
	foreignKey({
			columns: [table.user_id],
			foreignColumns: [users.id],
			name: "user_settings_user_id_fkey"
		}).onDelete("cascade"),
	unique("user_settings_user_id_key").on(table.user_id),
]);
