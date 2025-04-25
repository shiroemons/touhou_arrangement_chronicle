-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TYPE "public"."first_character_type" AS ENUM('symbol', 'number', 'alphabet', 'hiragana', 'katakana', 'kanji', 'other');--> statement-breakpoint
CREATE TYPE "public"."product_type" AS ENUM('pc98', 'windows', 'zuns_music_collection', 'akyus_untouched_score', 'commercial_books', 'tasofro', 'other');--> statement-breakpoint
CREATE TABLE "schema_migrations" (
	"version" varchar(128) PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE "products" (
	"id" text PRIMARY KEY NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"name_reading" text,
	"short_name" text NOT NULL,
	"product_type" "product_type" NOT NULL,
	"series_number" numeric(5, 2) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "original_songs" (
	"id" text PRIMARY KEY NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"product_id" text NOT NULL,
	"name" text NOT NULL,
	"name_reading" text,
	"composer" text,
	"arranger" text,
	"track_number" integer NOT NULL,
	"is_original" boolean DEFAULT false NOT NULL,
	"origin_original_song_id" text
);
--> statement-breakpoint
CREATE TABLE "distribution_services" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"service_name" text NOT NULL,
	"display_name" text NOT NULL,
	"base_urls" jsonb NOT NULL,
	"description" text,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "distribution_services_service_name_key" UNIQUE("service_name")
);
--> statement-breakpoint
CREATE TABLE "streamable_urls" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"streamable_type" text NOT NULL,
	"streamable_id" text NOT NULL,
	"service_name" text NOT NULL,
	"url" text NOT NULL,
	"description" text,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "streamable_urls_streamable_type_check" CHECK (streamable_type = ANY (ARRAY['Product'::text, 'OriginalSong'::text, 'Album'::text, 'Song'::text]))
);
--> statement-breakpoint
CREATE TABLE "event_series" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"display_name" text NOT NULL,
	"display_name_reading" text,
	"slug" text DEFAULT gen_random_uuid() NOT NULL,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "event_series_name_key" UNIQUE("name"),
	CONSTRAINT "event_series_slug_key" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "event_editions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"event_series_id" uuid NOT NULL,
	"name" text NOT NULL,
	"display_name" text NOT NULL,
	"display_name_reading" text,
	"slug" text DEFAULT gen_random_uuid() NOT NULL,
	"start_date" date,
	"end_date" date,
	"touhou_date" date,
	"description" text,
	"note" text,
	"url" text,
	"twitter_url" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "event_editions_slug_key" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "event_days" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"event_edition_id" uuid NOT NULL,
	"day_number" integer,
	"display_name" text,
	"event_date" date,
	"region_code" text DEFAULT 'JP' NOT NULL,
	"is_cancelled" boolean DEFAULT false NOT NULL,
	"is_online" boolean DEFAULT false NOT NULL,
	"description" text,
	"note" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "artists" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"note" text
);
--> statement-breakpoint
CREATE TABLE "artist_names" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"artist_id" uuid NOT NULL,
	"name" text NOT NULL,
	"name_reading" text,
	"is_main_name" boolean DEFAULT false NOT NULL,
	"first_character_type" "first_character_type" NOT NULL,
	"first_character" text,
	"first_character_row" text,
	"description" text,
	"note" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	CONSTRAINT "artist_names_check" CHECK (((first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NULL))),
	CONSTRAINT "artist_names_check1" CHECK (((first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NULL)))
);
--> statement-breakpoint
CREATE TABLE "reference_urls" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"referenceable_type" text NOT NULL,
	"referenceable_id" uuid NOT NULL,
	"url_type" text NOT NULL,
	"url" text NOT NULL,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "reference_urls_referenceable_type_check" CHECK (referenceable_type = ANY (ARRAY['ArtistName'::text, 'Album'::text, 'Circle'::text, 'Song'::text]))
);
--> statement-breakpoint
CREATE TABLE "circles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"name_reading" text,
	"slug" text DEFAULT gen_random_uuid() NOT NULL,
	"first_character_type" "first_character_type" NOT NULL,
	"first_character" text,
	"first_character_row" text,
	"description" text,
	"note" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	CONSTRAINT "circles_slug_key" UNIQUE("slug"),
	CONSTRAINT "circles_check" CHECK (((first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character IS NULL))),
	CONSTRAINT "circles_check1" CHECK (((first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND (first_character_row IS NULL)))
);
--> statement-breakpoint
CREATE TABLE "albums" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"name_reading" text,
	"slug" text DEFAULT gen_random_uuid() NOT NULL,
	"release_circle_id" uuid,
	"release_circle_name" text,
	"release_date" date,
	"release_year" integer,
	"release_month" integer,
	"event_day_id" uuid,
	"album_number" text,
	"credit" text,
	"introduction" text,
	"description" text,
	"note" text,
	"url" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "albums_slug_key" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "albums_circles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"album_id" uuid NOT NULL,
	"circle_id" uuid NOT NULL,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "album_prices" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"album_id" uuid NOT NULL,
	"price_type" text NOT NULL,
	"is_free" boolean DEFAULT false NOT NULL,
	"price" numeric NOT NULL,
	"currency" text DEFAULT 'JPY' NOT NULL,
	"tax_included" boolean DEFAULT false NOT NULL,
	"shop_id" uuid,
	"url" text,
	"description" text,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "album_prices_price_type_check" CHECK (price_type = ANY (ARRAY['event'::text, 'shop'::text])),
	CONSTRAINT "album_prices_check" CHECK (((is_free = true) AND (price = (0)::numeric)) OR ((is_free = false) AND (price > (0)::numeric)))
);
--> statement-breakpoint
CREATE TABLE "shops" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"display_name" text NOT NULL,
	"description" text,
	"note" text,
	"website_url" text,
	"base_urls" jsonb,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "shops_name_key" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "album_upcs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"album_id" uuid NOT NULL,
	"upc" text NOT NULL,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "album_discs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"album_id" uuid NOT NULL,
	"disc_number" integer,
	"name" text,
	"description" text,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "songs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"circle_id" uuid,
	"album_id" uuid,
	"name" text NOT NULL,
	"name_reading" text,
	"release_date" date,
	"release_year" integer,
	"release_month" integer,
	"slug" text DEFAULT gen_random_uuid() NOT NULL,
	"album_disc_id" uuid,
	"disc_number" integer,
	"track_number" integer,
	"length_time_ms" integer,
	"bpm" integer,
	"description" text,
	"note" text,
	"display_composer" text,
	"display_arranger" text,
	"display_rearranger" text,
	"display_lyricist" text,
	"display_vocalist" text,
	"display_original_song" text,
	"published_at" timestamp with time zone,
	"archived_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "songs_slug_key" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "song_lyrics" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"content" text NOT NULL,
	"language" text DEFAULT 'ja',
	"description" text,
	"note" text,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "song_bmps" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"bpm" integer NOT NULL,
	"start_time_ms" bigint,
	"end_time_ms" bigint,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "song_isrcs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"isrc" text NOT NULL,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "songs_arrange_circles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"circle_id" uuid NOT NULL,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "songs_original_songs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"original_song_id" text NOT NULL,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "songs_artist_roles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"artist_name_id" uuid NOT NULL,
	"artist_role_id" uuid NOT NULL,
	"connector" text,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "artist_roles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"display_name" text NOT NULL,
	"description" text,
	"note" text,
	CONSTRAINT "artist_roles_name_key" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "songs_genres" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"song_id" uuid NOT NULL,
	"genre_id" uuid NOT NULL,
	"start_time_ms" bigint,
	"end_time_ms" bigint,
	"locked_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "genres" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"note" text,
	CONSTRAINT "genres_name_key" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "genreable_genres" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"genreable_type" text NOT NULL,
	"genreable_id" uuid NOT NULL,
	"genre_id" uuid NOT NULL,
	"locked_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "genreable_genres_genreable_type_check" CHECK (genreable_type = ANY (ARRAY['Album'::text, 'Circle'::text, 'ArtistName'::text]))
);
--> statement-breakpoint
CREATE TABLE "tags" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"note" text,
	CONSTRAINT "tags_name_key" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "taggings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"taggable_type" text NOT NULL,
	"taggable_id" uuid NOT NULL,
	"tag_id" uuid NOT NULL,
	"locked_at" timestamp with time zone,
	"position" integer DEFAULT 1 NOT NULL,
	CONSTRAINT "taggings_taggable_type_check" CHECK (taggable_type = ANY (ARRAY['Album'::text, 'Song'::text, 'Circle'::text, 'ArtistName'::text]))
);
--> statement-breakpoint
CREATE TABLE "ar_internal_metadata" (
	"key" varchar PRIMARY KEY NOT NULL,
	"value" varchar,
	"created_at" timestamp(6) NOT NULL,
	"updated_at" timestamp(6) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "original_songs" ADD CONSTRAINT "original_songs_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "original_songs" ADD CONSTRAINT "original_songs_origin_original_song_id_fkey" FOREIGN KEY ("origin_original_song_id") REFERENCES "public"."original_songs"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "streamable_urls" ADD CONSTRAINT "streamable_urls_service_name_fkey" FOREIGN KEY ("service_name") REFERENCES "public"."distribution_services"("service_name") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_editions" ADD CONSTRAINT "event_editions_event_series_id_fkey" FOREIGN KEY ("event_series_id") REFERENCES "public"."event_series"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_days" ADD CONSTRAINT "event_days_event_edition_id_fkey" FOREIGN KEY ("event_edition_id") REFERENCES "public"."event_editions"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "artist_names" ADD CONSTRAINT "artist_names_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "public"."artists"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "albums" ADD CONSTRAINT "albums_release_circle_id_fkey" FOREIGN KEY ("release_circle_id") REFERENCES "public"."circles"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "albums" ADD CONSTRAINT "albums_event_day_id_fkey" FOREIGN KEY ("event_day_id") REFERENCES "public"."event_days"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "albums_circles" ADD CONSTRAINT "albums_circles_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "albums_circles" ADD CONSTRAINT "albums_circles_circle_id_fkey" FOREIGN KEY ("circle_id") REFERENCES "public"."circles"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "album_prices" ADD CONSTRAINT "album_prices_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "album_prices" ADD CONSTRAINT "album_prices_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "public"."shops"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "album_upcs" ADD CONSTRAINT "album_upcs_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "album_discs" ADD CONSTRAINT "album_discs_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs" ADD CONSTRAINT "songs_circle_id_fkey" FOREIGN KEY ("circle_id") REFERENCES "public"."circles"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs" ADD CONSTRAINT "songs_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs" ADD CONSTRAINT "songs_album_disc_id_fkey" FOREIGN KEY ("album_disc_id") REFERENCES "public"."album_discs"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "song_lyrics" ADD CONSTRAINT "song_lyrics_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "song_bmps" ADD CONSTRAINT "song_bmps_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "song_isrcs" ADD CONSTRAINT "song_isrcs_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_arrange_circles" ADD CONSTRAINT "songs_arrange_circles_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_arrange_circles" ADD CONSTRAINT "songs_arrange_circles_circle_id_fkey" FOREIGN KEY ("circle_id") REFERENCES "public"."circles"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_original_songs" ADD CONSTRAINT "songs_original_songs_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_original_songs" ADD CONSTRAINT "songs_original_songs_original_song_id_fkey" FOREIGN KEY ("original_song_id") REFERENCES "public"."original_songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_artist_roles" ADD CONSTRAINT "songs_artist_roles_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_artist_roles" ADD CONSTRAINT "songs_artist_roles_artist_name_id_fkey" FOREIGN KEY ("artist_name_id") REFERENCES "public"."artist_names"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_artist_roles" ADD CONSTRAINT "songs_artist_roles_artist_role_id_fkey" FOREIGN KEY ("artist_role_id") REFERENCES "public"."artist_roles"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_genres" ADD CONSTRAINT "songs_genres_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "public"."songs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "songs_genres" ADD CONSTRAINT "songs_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "public"."genres"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "genreable_genres" ADD CONSTRAINT "genreable_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "public"."genres"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "taggings" ADD CONSTRAINT "taggings_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "public"."tags"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "idx_products_product_type" ON "products" USING btree ("product_type" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_products_series_number" ON "products" USING btree ("series_number" numeric_ops);--> statement-breakpoint
CREATE INDEX "idx_original_songs_is_original" ON "original_songs" USING btree ("is_original" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_original_songs_origin_original_song_id" ON "original_songs" USING btree ("origin_original_song_id" text_ops);--> statement-breakpoint
CREATE INDEX "idx_original_songs_product_id" ON "original_songs" USING btree ("product_id" text_ops);--> statement-breakpoint
CREATE INDEX "idx_original_songs_product_original" ON "original_songs" USING btree ("product_id" text_ops,"is_original" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_original_songs_track_number" ON "original_songs" USING btree ("track_number" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_distribution_services_base_urls" ON "distribution_services" USING gin ("base_urls" jsonb_ops);--> statement-breakpoint
CREATE INDEX "idx_distribution_services_position" ON "distribution_services" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_streamable_urls_service_name" ON "streamable_urls" USING btree ("service_name" text_ops);--> statement-breakpoint
CREATE INDEX "idx_streamable_urls_type_service" ON "streamable_urls" USING btree ("streamable_type" text_ops,"service_name" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_streamable_urls_streamable_id_service" ON "streamable_urls" USING btree ("streamable_type" text_ops,"streamable_id" text_ops,"service_name" text_ops);--> statement-breakpoint
CREATE INDEX "idx_event_series_archived_at" ON "event_series" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_series_position" ON "event_series" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_event_series_published_at" ON "event_series" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_archived_at" ON "event_editions" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_end_date" ON "event_editions" USING btree ("end_date" date_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_event_series_id" ON "event_editions" USING btree ("event_series_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_position" ON "event_editions" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_published_at" ON "event_editions" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_start_date" ON "event_editions" USING btree ("start_date" date_ops);--> statement-breakpoint
CREATE INDEX "idx_event_editions_touhou_date" ON "event_editions" USING btree ("touhou_date" date_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_event_editions_event_series_id_name" ON "event_editions" USING btree ("event_series_id" uuid_ops,"name" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_archived_at" ON "event_days" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_comprehensive" ON "event_days" USING btree ("event_edition_id" date_ops,"event_date" uuid_ops,"is_cancelled" uuid_ops,"is_online" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_event_date" ON "event_days" USING btree ("event_date" date_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_event_edition_id" ON "event_days" USING btree ("event_edition_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_is_cancelled" ON "event_days" USING btree ("is_cancelled" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_is_online" ON "event_days" USING btree ("is_online" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_published_at" ON "event_days" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_event_days_region_code" ON "event_days" USING btree ("region_code" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_event_days_event_edition_id_day_number_is_online" ON "event_days" USING btree ("event_edition_id" int4_ops,"day_number" int4_ops,"is_online" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_artists_name" ON "artists" USING btree ("name" text_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_archived_at" ON "artist_names" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_artist_id" ON "artist_names" USING btree ("artist_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_comprehensive" ON "artist_names" USING btree ("first_character_type" text_ops,"first_character" text_ops,"first_character_row" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_first_character" ON "artist_names" USING btree ("first_character_type" enum_ops,"first_character" text_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_first_character_type" ON "artist_names" USING btree ("first_character_type" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_artist_names_published_at" ON "artist_names" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_artist_names_artist_id_main_name" ON "artist_names" USING btree ("artist_id" uuid_ops,"is_main_name" uuid_ops) WHERE (is_main_name = true);--> statement-breakpoint
CREATE INDEX "idx_reference_urls_referenceable" ON "reference_urls" USING btree ("referenceable_type" text_ops,"referenceable_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_reference_urls_url_type" ON "reference_urls" USING btree ("url_type" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_reference_urls_referenceable_type_referenceable_id_url" ON "reference_urls" USING btree ("referenceable_type" uuid_ops,"referenceable_id" uuid_ops,"url" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_circles_archived_at" ON "circles" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_circles_comprehensive" ON "circles" USING btree ("first_character_type" enum_ops,"first_character" enum_ops,"first_character_row" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_circles_first_character" ON "circles" USING btree ("first_character_type" text_ops,"first_character" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_circles_first_character_type" ON "circles" USING btree ("first_character_type" enum_ops);--> statement-breakpoint
CREATE INDEX "idx_circles_published_at" ON "circles" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_circles_name" ON "circles" USING btree ("name" text_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_archived_at" ON "albums" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_comprehensive_release" ON "albums" USING btree ("release_year" int4_ops,"release_month" date_ops,"release_date" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_event_day_id" ON "albums" USING btree ("event_day_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_publication_status" ON "albums" USING btree (COALESCE(published_at, '1970-01-01 00:00:00+00'::timestamp with timestamptz_ops,COALESCE(archived_at, '9999-12-31 00:00:00+00'::timestamp with  timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_published_at" ON "albums" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_release_circle_id" ON "albums" USING btree ("release_circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_release_date" ON "albums" USING btree ("release_date" date_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_release_month" ON "albums" USING btree ("release_month" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_release_year" ON "albums" USING btree ("release_year" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_release_year_month" ON "albums" USING btree ("release_year" int4_ops,"release_month" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_circles_album_id" ON "albums_circles" USING btree ("album_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_circles_circle_id" ON "albums_circles" USING btree ("circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_albums_circles_position" ON "albums_circles" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_albums_circles_album_id_circle_id" ON "albums_circles" USING btree ("album_id" uuid_ops,"circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_album_id" ON "album_prices" USING btree ("album_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_album_id_price_type" ON "album_prices" USING btree ("album_id" text_ops,"price_type" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_combined" ON "album_prices" USING btree ("price_type" bool_ops,"is_free" text_ops,"currency" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_price_type" ON "album_prices" USING btree ("price_type" text_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_shop_id" ON "album_prices" USING btree ("shop_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_prices_shop_id_price_type" ON "album_prices" USING btree ("shop_id" uuid_ops,"price_type" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_ap_album_id_shop_id" ON "album_prices" USING btree ("album_id" uuid_ops,"shop_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_shops_archived_at" ON "shops" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_shops_position" ON "shops" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_shops_published_at" ON "shops" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_album_upcs_album_id" ON "album_upcs" USING btree ("album_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_upcs_position" ON "album_upcs" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_album_upcs_album_id_upc" ON "album_upcs" USING btree ("album_id" uuid_ops,"upc" text_ops);--> statement-breakpoint
CREATE INDEX "idx_album_discs_album_id" ON "album_discs" USING btree ("album_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_album_discs_disc_number" ON "album_discs" USING btree ("disc_number" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_album_discs_position" ON "album_discs" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_album_id" ON "songs" USING btree ("album_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_album_track" ON "songs" USING btree ("album_id" int4_ops,"track_number" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_archived_at" ON "songs" USING btree ("archived_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_circle_id" ON "songs" USING btree ("circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_comprehensive_release" ON "songs" USING btree ("release_year" int4_ops,"release_month" int4_ops,"release_date" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_disc_tracking" ON "songs" USING btree ("album_id" int4_ops,"disc_number" int4_ops,"track_number" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_published_at" ON "songs" USING btree ("published_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_release_date" ON "songs" USING btree ("release_date" date_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_release_month" ON "songs" USING btree ("release_month" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_release_year" ON "songs" USING btree ("release_year" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_release_year_month" ON "songs" USING btree ("release_year" int4_ops,"release_month" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_song_lyrics_position" ON "song_lyrics" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_song_lyrics_song_id" ON "song_lyrics" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_song_bmps_position" ON "song_bmps" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_song_bmps_song_id" ON "song_bmps" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_song_isrcs_position" ON "song_isrcs" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_song_isrcs_song_id" ON "song_isrcs" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_song_isrcs_song_id_isrc" ON "song_isrcs" USING btree ("song_id" uuid_ops,"isrc" text_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_arrange_circles_circle_id" ON "songs_arrange_circles" USING btree ("circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_arrange_circles_combined" ON "songs_arrange_circles" USING btree ("circle_id" int4_ops,"song_id" uuid_ops,"position" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_arrange_circles_song_id" ON "songs_arrange_circles" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_songs_arrange_circles_song_id_circle_id" ON "songs_arrange_circles" USING btree ("song_id" uuid_ops,"circle_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_original_songs_original_song_id" ON "songs_original_songs" USING btree ("original_song_id" text_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_original_songs_position" ON "songs_original_songs" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_original_songs_song_id" ON "songs_original_songs" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_songs_original_songs_song_id_original_song_id" ON "songs_original_songs" USING btree ("song_id" uuid_ops,"original_song_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_artist_roles_artist_name_id" ON "songs_artist_roles" USING btree ("artist_name_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_artist_roles_artist_role_id" ON "songs_artist_roles" USING btree ("artist_role_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_artist_roles_combined" ON "songs_artist_roles" USING btree ("song_id" uuid_ops,"artist_role_id" uuid_ops,"position" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_artist_roles_song_id" ON "songs_artist_roles" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_sar_song_id_artist_name_id_artist_role_id" ON "songs_artist_roles" USING btree ("song_id" uuid_ops,"artist_name_id" uuid_ops,"artist_role_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_genres_genre_id" ON "songs_genres" USING btree ("genre_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_genres_locked_at" ON "songs_genres" USING btree ("locked_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_genres_position" ON "songs_genres" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_genres_song_id" ON "songs_genres" USING btree ("song_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_songs_genres_song_id_genre_id" ON "songs_genres" USING btree ("song_id" uuid_ops,"genre_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "idx_genreable_genres_locked_at" ON "genreable_genres" USING btree ("locked_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_genreable_genres_position" ON "genreable_genres" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_genreable_genres_genreable_type_genreable_id_genre_id" ON "genreable_genres" USING btree ("genreable_type" uuid_ops,"genreable_id" text_ops,"genre_id" text_ops);--> statement-breakpoint
CREATE INDEX "idx_taggings_locked_at" ON "taggings" USING btree ("locked_at" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "idx_taggings_position" ON "taggings" USING btree ("position" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "uk_taggings_taggable" ON "taggings" USING btree ("taggable_type" uuid_ops,"taggable_id" text_ops,"tag_id" text_ops);
*/