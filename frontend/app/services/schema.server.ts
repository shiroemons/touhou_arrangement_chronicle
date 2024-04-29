import { sql } from "drizzle-orm";
import {
  boolean,
  date,
  foreignKey,
  integer,
  numeric,
  pgEnum,
  pgTable,
  primaryKey,
  text,
  timestamp,
  unique,
  uniqueIndex,
  varchar,
} from "drizzle-orm/pg-core";

export const productType = pgEnum("product_type", [
  "other",
  "tasofro",
  "commercial_books",
  "akyus_untouched_score",
  "zuns_music_collection",
  "windows",
  "pc98",
]);
export const distributionService = pgEnum("distribution_service", [
  "sound_cloud",
  "nicovideo",
  "youtube",
  "itunes",
  "line_music",
  "youtube_music",
  "apple_music",
  "spotify",
]);
export const eventStatus = pgEnum("event_status", [
  "completed",
  "other",
  "moved_online",
  "rescheduled",
  "postpone",
  "cancelled",
  "scheduled",
]);
export const eventFormat = pgEnum("event_format", [
  "mixed",
  "online",
  "offline",
]);
export const initialLetterType = pgEnum("initial_letter_type", [
  "other",
  "kanji",
  "katakana",
  "hiragana",
  "alphabet",
  "number",
  "symbol",
]);
export const shop = pgEnum("shop", [
  "toranoana",
  "tanocstore",
  "melonbooks",
  "grep",
  "diverse_direct",
  "booth",
  "bookmate",
  "animate",
  "akibaoo",
  "akiba_hobby",
]);
export const tagType = pgEnum("tag_type", [
  "instrument",
  "ambience",
  "genre",
  "unknown",
]);

export const songs = pgTable(
  "songs",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    circleId: text("circle_id"),
    albumId: text("album_id"),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    discNumber: integer("disc_number").default(1).notNull(),
    trackNumber: integer("track_number").notNull(),
    releaseDate: date("release_date"),
    length: integer("length"),
    bpm: integer("bpm"),
    description: text("description"),
    displayComposer: text("display_composer"),
    displayArranger: text("display_arranger"),
    displayRearranger: text("display_rearranger"),
    displayLyricist: text("display_lyricist"),
    displayVocalist: text("display_vocalist"),
    displayOriginalSong: text("display_original_song"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsSlugKey: unique("songs_slug_key").on(table.slug),
    };
  },
);

export const lyrics = pgTable("lyrics", {
  id: text("id").default(sql`cuid()`).primaryKey().notNull(),
  songId: text("song_id")
    .notNull()
    .references(() => songs.id),
  content: text("content").notNull(),
  language: text("language").default("ja"),
  createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
});

export const songDistributionServiceUrls = pgTable(
  "song_distribution_service_urls",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    service: distributionService("service").notNull(),
    url: text("url").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukSdsuSongIdService: uniqueIndex("uk_sdsu_song_id_service").on(
        table.songId,
        table.service,
      ),
    };
  },
);

export const songIsrcs = pgTable(
  "song_isrcs",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    isrc: text("isrc").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukSongIsrcsSongIdIsrc: uniqueIndex("uk_song_isrcs_song_id_isrc").on(
        table.songId,
        table.isrc,
      ),
    };
  },
);

export const artists = pgTable(
  "artists",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    initialLetterType: initialLetterType("initial_letter_type").notNull(),
    initialLetterDetail: text("initial_letter_detail"),
    description: text("description"),
    url: text("url"),
    blogUrl: text("blog_url"),
    twitterUrl: text("twitter_url"),
    youtubeChannelUrl: text("youtube_channel_url"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      artistsSlugKey: unique("artists_slug_key").on(table.slug),
    };
  },
);

export const adminUsers = pgTable(
  "admin_users",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name"),
    email: text("email").default("").notNull(),
    encryptedPassword: text("encrypted_password").default("").notNull(),
    resetPasswordToken: text("reset_password_token"),
    resetPasswordSentAt: timestamp("reset_password_sent_at", {
      withTimezone: true,
      mode: "string",
    }),
    rememberCreatedAt: timestamp("remember_created_at", {
      withTimezone: true,
      mode: "string",
    }),
    signInCount: integer("sign_in_count").default(0).notNull(),
    currentSignInAt: timestamp("current_sign_in_at", {
      withTimezone: true,
      mode: "string",
    }),
    lastSignInAt: timestamp("last_sign_in_at", {
      withTimezone: true,
      mode: "string",
    }),
    currentSignInIp: text("current_sign_in_ip"),
    lastSignInIp: text("last_sign_in_ip"),
    confirmationToken: text("confirmation_token"),
    confirmedAt: timestamp("confirmed_at", {
      withTimezone: true,
      mode: "string",
    }),
    confirmationSentAt: timestamp("confirmation_sent_at", {
      withTimezone: true,
      mode: "string",
    }),
    unconfirmedEmail: text("unconfirmed_email"),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      indexAdminUsersOnEmail: uniqueIndex("index_admin_users_on_email").on(
        table.email,
      ),
      indexAdminUsersOnResetPasswordToken: uniqueIndex(
        "index_admin_users_on_reset_password_token",
      ).on(table.resetPasswordToken),
      indexAdminUsersOnConfirmationToken: uniqueIndex(
        "index_admin_users_on_confirmation_token",
      ).on(table.confirmationToken),
    };
  },
);

export const products = pgTable("products", {
  id: text("id").primaryKey().notNull(),
  name: text("name").notNull(),
  nameReading: text("name_reading"),
  shortName: text("short_name").notNull(),
  productType: productType("product_type").notNull(),
  seriesNumber: numeric("series_number", { precision: 5, scale: 2 }).notNull(),
  createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
});

export const originalSongs = pgTable("original_songs", {
  id: text("id").primaryKey().notNull(),
  productId: text("product_id")
    .notNull()
    .references(() => products.id),
  name: text("name").notNull(),
  nameReading: text("name_reading"),
  composer: text("composer"),
  arranger: text("arranger"),
  trackNumber: integer("track_number").notNull(),
  isOriginal: boolean("is_original").default(false).notNull(),
  sourceId: text("source_id"),
  createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
});

export const productDistributionServiceUrls = pgTable(
  "product_distribution_service_urls",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    productId: text("product_id")
      .notNull()
      .references(() => products.id),
    service: distributionService("service").notNull(),
    url: text("url").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukPdsuProductIdService: uniqueIndex("uk_pdsu_product_id_service").on(
        table.productId,
        table.service,
      ),
    };
  },
);

export const originalSongDistributionServiceUrls = pgTable(
  "original_song_distribution_service_urls",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    originalSongId: text("original_song_id")
      .notNull()
      .references(() => originalSongs.id),
    service: distributionService("service").notNull(),
    url: text("url").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukOsdsuOriginalSongIdService: uniqueIndex(
        "uk_osdsu_original_song_id_service",
      ).on(table.originalSongId, table.service),
    };
  },
);

export const events = pgTable(
  "events",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    eventSeriesId: text("event_series_id")
      .notNull()
      .references(() => eventSeries.id),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    displayName: text("display_name").notNull(),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    eventStatus: eventStatus("event_status").default("scheduled").notNull(),
    format: eventFormat("format").default("offline").notNull(),
    regionCode: text("region_code").default("JP").notNull(),
    address: text("address"),
    description: text("description"),
    url: text("url"),
    twitterUrl: text("twitter_url"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    startDate: date("start_date"),
    endDate: date("end_date"),
  },
  (table) => {
    return {
      eventsNameKey: unique("events_name_key").on(table.name),
      eventsSlugKey: unique("events_slug_key").on(table.slug),
    };
  },
);

export const eventSeries = pgTable(
  "event_series",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    displayName: text("display_name").notNull(),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      eventSeriesNameKey: unique("event_series_name_key").on(table.name),
      eventSeriesSlugKey: unique("event_series_slug_key").on(table.slug),
    };
  },
);

export const subEvents = pgTable(
  "sub_events",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    eventId: text("event_id")
      .notNull()
      .references(() => events.id),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    displayName: text("display_name").notNull(),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    eventDate: date("event_date"),
    eventStatus: eventStatus("event_status").default("scheduled").notNull(),
    description: text("description"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      subEventsNameKey: unique("sub_events_name_key").on(table.name),
      subEventsSlugKey: unique("sub_events_slug_key").on(table.slug),
    };
  },
);

export const albums = pgTable(
  "albums",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    releaseCircleName: text("release_circle_name"),
    releaseDate: date("release_date"),
    eventId: text("event_id"),
    subEventId: text("sub_event_id"),
    albumNumber: text("album_number"),
    eventPrice: numeric("event_price"),
    currency: text("currency").default("JPY").notNull(),
    credit: text("credit"),
    introduction: text("introduction"),
    url: text("url"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      albumsSlugKey: unique("albums_slug_key").on(table.slug),
    };
  },
);

export const circles = pgTable(
  "circles",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    nameReading: text("name_reading"),
    slug: text("slug").default(sql`gen_random_uuid()`).notNull(),
    initialLetterType: initialLetterType("initial_letter_type").notNull(),
    initialLetterDetail: text("initial_letter_detail"),
    description: text("description"),
    url: text("url"),
    blogUrl: text("blog_url"),
    twitterUrl: text("twitter_url"),
    youtubeChannelUrl: text("youtube_channel_url"),
    publishedAt: timestamp("published_at", {
      withTimezone: true,
      mode: "string",
    }),
    archivedAt: timestamp("archived_at", {
      withTimezone: true,
      mode: "string",
    }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      circlesSlugKey: unique("circles_slug_key").on(table.slug),
    };
  },
);

export const albumConsignmentShops = pgTable("album_consignment_shops", {
  id: text("id").default(sql`cuid()`).primaryKey().notNull(),
  albumId: text("album_id")
    .notNull()
    .references(() => albums.id),
  shop: shop("shop").notNull(),
  url: text("url").notNull(),
  taxIncluded: boolean("tax_included").default(false).notNull(),
  shopPrice: numeric("shop_price").notNull(),
  currency: text("currency").default("JPY").notNull(),
  createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
    .defaultNow()
    .notNull(),
});

export const albumDistributionServiceUrls = pgTable(
  "album_distribution_service_urls",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    albumId: text("album_id")
      .notNull()
      .references(() => albums.id),
    service: distributionService("service").notNull(),
    url: text("url").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukAdsuAlbumIdService: uniqueIndex("uk_adsu_album_id_service").on(
        table.albumId,
        table.service,
      ),
    };
  },
);

export const albumUpcs = pgTable(
  "album_upcs",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    albumId: text("album_id")
      .notNull()
      .references(() => albums.id),
    upc: text("upc").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukAlbumUpcsAlbumIdUpc: uniqueIndex("uk_album_upcs_album_id_upc").on(
        table.albumId,
        table.upc,
      ),
    };
  },
);

export const albumsGenres = pgTable(
  "albums_genres",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    albumId: text("album_id")
      .notNull()
      .references(() => albums.id),
    genreId: text("genre_id")
      .notNull()
      .references(() => genres.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukAlbumsGenresAlbumIdGenreId: uniqueIndex(
        "uk_albums_genres_album_id_genre_id",
      ).on(table.albumId, table.genreId),
    };
  },
);

export const genres = pgTable(
  "genres",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      genresNameKey: unique("genres_name_key").on(table.name),
    };
  },
);

export const albumsTags = pgTable(
  "albums_tags",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    albumId: text("album_id")
      .notNull()
      .references(() => albums.id),
    tagId: text("tag_id")
      .notNull()
      .references(() => tags.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukAlbumsTagsSongIdTagId: uniqueIndex("uk_albums_tags_song_id_tag_id").on(
        table.albumId,
        table.tagId,
      ),
    };
  },
);

export const tags = pgTable(
  "tags",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    name: text("name").notNull(),
    tagType: tagType("tag_type").default("unknown").notNull(),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      tagsNameKey: unique("tags_name_key").on(table.name),
    };
  },
);

export const songsGenres = pgTable(
  "songs_genres",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    genreId: text("genre_id")
      .notNull()
      .references(() => genres.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukSongsGenresSongIdGenreId: uniqueIndex(
        "uk_songs_genres_song_id_genre_id",
      ).on(table.songId, table.genreId),
    };
  },
);

export const songsTags = pgTable(
  "songs_tags",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    tagId: text("tag_id")
      .notNull()
      .references(() => tags.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukSongsTagsSongIdTagId: uniqueIndex("uk_songs_tags_song_id_tag_id").on(
        table.songId,
        table.tagId,
      ),
    };
  },
);

export const circlesGenres = pgTable(
  "circles_genres",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    circleId: text("circle_id")
      .notNull()
      .references(() => circles.id),
    genreId: text("genre_id")
      .notNull()
      .references(() => genres.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukCirclesGenresCircleIdGenreId: uniqueIndex(
        "uk_circles_genres_circle_id_genre_id",
      ).on(table.circleId, table.genreId),
    };
  },
);

export const circlesTags = pgTable(
  "circles_tags",
  {
    id: text("id").default(sql`cuid()`).primaryKey().notNull(),
    circleId: text("circle_id")
      .notNull()
      .references(() => circles.id),
    tagId: text("tag_id")
      .notNull()
      .references(() => tags.id),
    lockedAt: timestamp("locked_at", { withTimezone: true, mode: "string" }),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      ukCirclesTagsCircleIdTagId: uniqueIndex(
        "uk_circles_tags_circle_id_tag_id",
      ).on(table.circleId, table.tagId),
    };
  },
);

export const schemaMigrations = pgTable("schema_migrations", {
  version: varchar("version").primaryKey().notNull(),
});

export const arInternalMetadata = pgTable("ar_internal_metadata", {
  key: varchar("key").primaryKey().notNull(),
  value: varchar("value"),
  createdAt: timestamp("created_at", {
    precision: 6,
    mode: "string",
  }).notNull(),
  updatedAt: timestamp("updated_at", {
    precision: 6,
    mode: "string",
  }).notNull(),
});

export const songsArrangeCircles = pgTable(
  "songs_arrange_circles",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    circleId: text("circle_id")
      .notNull()
      .references(() => circles.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsArrangeCirclesPkey: primaryKey({
        columns: [table.songId, table.circleId],
        name: "songs_arrange_circles_pkey",
      }),
    };
  },
);

export const songsComposers = pgTable(
  "songs_composers",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    artistId: text("artist_id")
      .notNull()
      .references(() => artists.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsComposersPkey: primaryKey({
        columns: [table.songId, table.artistId],
        name: "songs_composers_pkey",
      }),
    };
  },
);

export const albumsCircles = pgTable(
  "albums_circles",
  {
    albumId: text("album_id")
      .notNull()
      .references(() => albums.id),
    circleId: text("circle_id")
      .notNull()
      .references(() => circles.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      albumsCirclesPkey: primaryKey({
        columns: [table.albumId, table.circleId],
        name: "albums_circles_pkey",
      }),
    };
  },
);

export const songsArrangers = pgTable(
  "songs_arrangers",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    artistId: text("artist_id")
      .notNull()
      .references(() => artists.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsArrangersPkey: primaryKey({
        columns: [table.songId, table.artistId],
        name: "songs_arrangers_pkey",
      }),
    };
  },
);

export const songsRearrangers = pgTable(
  "songs_rearrangers",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    artistId: text("artist_id")
      .notNull()
      .references(() => artists.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsRearrangersPkey: primaryKey({
        columns: [table.songId, table.artistId],
        name: "songs_rearrangers_pkey",
      }),
    };
  },
);

export const songsLyricists = pgTable(
  "songs_lyricists",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    artistId: text("artist_id")
      .notNull()
      .references(() => artists.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsLyricistsPkey: primaryKey({
        columns: [table.songId, table.artistId],
        name: "songs_lyricists_pkey",
      }),
    };
  },
);

export const songsVocalists = pgTable(
  "songs_vocalists",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    artistId: text("artist_id")
      .notNull()
      .references(() => artists.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsVocalistsPkey: primaryKey({
        columns: [table.songId, table.artistId],
        name: "songs_vocalists_pkey",
      }),
    };
  },
);

export const songsOriginalSongs = pgTable(
  "songs_original_songs",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    originalSongId: text("original_song_id")
      .notNull()
      .references(() => originalSongs.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsOriginalSongsPkey: primaryKey({
        columns: [table.songId, table.originalSongId],
        name: "songs_original_songs_pkey",
      }),
    };
  },
);

export const songsCircles = pgTable(
  "songs_circles",
  {
    songId: text("song_id")
      .notNull()
      .references(() => songs.id),
    circleId: text("circle_id")
      .notNull()
      .references(() => circles.id),
    createdAt: timestamp("created_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true, mode: "string" })
      .defaultNow()
      .notNull(),
  },
  (table) => {
    return {
      songsCirclesPkey: primaryKey({
        columns: [table.songId, table.circleId],
        name: "songs_circles_pkey",
      }),
    };
  },
);
