import { uuid, varchar, text, integer, boolean, timestamp, pgEnum, pgTable } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

// 列挙型の定義
export const firstCharacterTypeEnum = pgEnum('first_character_type', [
  'symbol',
  'number',
  'alphabet',
  'hiragana',
  'katakana',
  'kanji',
  'other'
]);

export const productTypeEnum = pgEnum('product_type', [
  'pc98',
  'windows',
  'zuns_music_collection',
  'akyus_untouched_score',
  'commercial_books',
  'tasofro',
  'other'
]);

// テーブルの定義
export const artists = pgTable('artists', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  name: text('name').notNull(),
  description: text('description'),
  note: text('note')
});

export const artistNames = pgTable('artist_names', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  artistId: uuid('artist_id').notNull().references(() => artists.id),
  name: text('name').notNull(),
  displayName: text('display_name'),
  firstCharacterType: firstCharacterTypeEnum('first_character_type'),
  firstCharacter: text('first_character'),
  firstCharacterRow: text('first_character_row'),
  isMainName: boolean('is_main_name').default(false).notNull(),
  publishedAt: timestamp('published_at'),
  archivedAt: timestamp('archived_at'),
  note: text('note')
});

export const artistRoles = pgTable('artist_roles', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  name: text('name').notNull(),
  displayName: text('display_name'),
  description: text('description'),
  note: text('note'),
  position: integer('position').default(1).notNull()
});

export const songs = pgTable('songs', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  albumId: uuid('album_id').notNull(),
  discNumber: integer('disc_number'),
  trackNumber: integer('track_number'),
  name: text('name').notNull(),
  nameReading: text('name_reading'),
  displayName: text('display_name'),
  length: integer('length'),
  bpm: integer('bpm'),
  releaseDate: timestamp('release_date'),
  releaseYear: integer('release_year'),
  releaseMonth: integer('release_month'),
  slug: text('slug').notNull().default(sql`gen_random_uuid()`),
  description: text('description'),
  note: text('note'),
  circleId: uuid('circle_id'),
  publishedAt: timestamp('published_at'),
  archivedAt: timestamp('archived_at')
});

export const songsArtistRoles = pgTable('songs_artist_roles', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
  songId: uuid('song_id').notNull().references(() => songs.id),
  artistRoleId: uuid('artist_role_id').notNull().references(() => artistRoles.id),
  artistNameId: uuid('artist_name_id').notNull(),
  position: integer('position').default(1).notNull()
});

// Newsテーブル定義
export const news = pgTable('news', {
  id: uuid('id').primaryKey().defaultRandom(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  title: text('title').notNull(),
  content: text('content').notNull(),
  summary: text('summary'),
  slug: text('slug').notNull().unique().default(sql`gen_random_uuid()`),
  publishedAt: timestamp('published_at', { withTimezone: true }).notNull(),
  expiredAt: timestamp('expired_at', { withTimezone: true }),
  isImportant: boolean('is_important').notNull().default(false),
  category: text('category'),
}); 