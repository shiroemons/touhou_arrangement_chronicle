import { relations } from "drizzle-orm/relations";
import { products, original_songs, distribution_services, streamable_urls, event_series, event_editions, event_days, artists, artist_names, circles, albums, albums_circles, album_prices, shops, album_upcs, album_discs, songs, song_lyrics, song_bmps, song_isrcs, songs_arrange_circles, songs_original_songs, songs_artist_roles, artist_roles, songs_genres, genres, genreable_genres, tags, taggings } from "./schema";

export const original_songsRelations = relations(original_songs, ({one, many}) => ({
	product: one(products, {
		fields: [original_songs.product_id],
		references: [products.id]
	}),
	original_song: one(original_songs, {
		fields: [original_songs.origin_original_song_id],
		references: [original_songs.id],
		relationName: "original_songs_origin_original_song_id_original_songs_id"
	}),
	original_songs: many(original_songs, {
		relationName: "original_songs_origin_original_song_id_original_songs_id"
	}),
	songs_original_songs: many(songs_original_songs),
}));

export const productsRelations = relations(products, ({many}) => ({
	original_songs: many(original_songs),
}));

export const streamable_urlsRelations = relations(streamable_urls, ({one}) => ({
	distribution_service: one(distribution_services, {
		fields: [streamable_urls.service_name],
		references: [distribution_services.service_name]
	}),
}));

export const distribution_servicesRelations = relations(distribution_services, ({many}) => ({
	streamable_urls: many(streamable_urls),
}));

export const event_editionsRelations = relations(event_editions, ({one, many}) => ({
	event_sery: one(event_series, {
		fields: [event_editions.event_series_id],
		references: [event_series.id]
	}),
	event_days: many(event_days),
}));

export const event_seriesRelations = relations(event_series, ({many}) => ({
	event_editions: many(event_editions),
}));

export const event_daysRelations = relations(event_days, ({one, many}) => ({
	event_edition: one(event_editions, {
		fields: [event_days.event_edition_id],
		references: [event_editions.id]
	}),
	albums: many(albums),
}));

export const artist_namesRelations = relations(artist_names, ({one, many}) => ({
	artist: one(artists, {
		fields: [artist_names.artist_id],
		references: [artists.id]
	}),
	songs_artist_roles: many(songs_artist_roles),
}));

export const artistsRelations = relations(artists, ({many}) => ({
	artist_names: many(artist_names),
}));

export const albumsRelations = relations(albums, ({one, many}) => ({
	circle: one(circles, {
		fields: [albums.release_circle_id],
		references: [circles.id]
	}),
	event_day: one(event_days, {
		fields: [albums.event_day_id],
		references: [event_days.id]
	}),
	albums_circles: many(albums_circles),
	album_prices: many(album_prices),
	album_upcs: many(album_upcs),
	album_discs: many(album_discs),
	songs: many(songs),
}));

export const circlesRelations = relations(circles, ({many}) => ({
	albums: many(albums),
	albums_circles: many(albums_circles),
	songs: many(songs),
	songs_arrange_circles: many(songs_arrange_circles),
}));

export const albums_circlesRelations = relations(albums_circles, ({one}) => ({
	album: one(albums, {
		fields: [albums_circles.album_id],
		references: [albums.id]
	}),
	circle: one(circles, {
		fields: [albums_circles.circle_id],
		references: [circles.id]
	}),
}));

export const album_pricesRelations = relations(album_prices, ({one}) => ({
	album: one(albums, {
		fields: [album_prices.album_id],
		references: [albums.id]
	}),
	shop: one(shops, {
		fields: [album_prices.shop_id],
		references: [shops.id]
	}),
}));

export const shopsRelations = relations(shops, ({many}) => ({
	album_prices: many(album_prices),
}));

export const album_upcsRelations = relations(album_upcs, ({one}) => ({
	album: one(albums, {
		fields: [album_upcs.album_id],
		references: [albums.id]
	}),
}));

export const album_discsRelations = relations(album_discs, ({one, many}) => ({
	album: one(albums, {
		fields: [album_discs.album_id],
		references: [albums.id]
	}),
	songs: many(songs),
}));

export const songsRelations = relations(songs, ({one, many}) => ({
	circle: one(circles, {
		fields: [songs.circle_id],
		references: [circles.id]
	}),
	album: one(albums, {
		fields: [songs.album_id],
		references: [albums.id]
	}),
	album_disc: one(album_discs, {
		fields: [songs.album_disc_id],
		references: [album_discs.id]
	}),
	song_lyrics: many(song_lyrics),
	song_bmps: many(song_bmps),
	song_isrcs: many(song_isrcs),
	songs_arrange_circles: many(songs_arrange_circles),
	songs_original_songs: many(songs_original_songs),
	songs_artist_roles: many(songs_artist_roles),
	songs_genres: many(songs_genres),
}));

export const song_lyricsRelations = relations(song_lyrics, ({one}) => ({
	song: one(songs, {
		fields: [song_lyrics.song_id],
		references: [songs.id]
	}),
}));

export const song_bmpsRelations = relations(song_bmps, ({one}) => ({
	song: one(songs, {
		fields: [song_bmps.song_id],
		references: [songs.id]
	}),
}));

export const song_isrcsRelations = relations(song_isrcs, ({one}) => ({
	song: one(songs, {
		fields: [song_isrcs.song_id],
		references: [songs.id]
	}),
}));

export const songs_arrange_circlesRelations = relations(songs_arrange_circles, ({one}) => ({
	song: one(songs, {
		fields: [songs_arrange_circles.song_id],
		references: [songs.id]
	}),
	circle: one(circles, {
		fields: [songs_arrange_circles.circle_id],
		references: [circles.id]
	}),
}));

export const songs_original_songsRelations = relations(songs_original_songs, ({one}) => ({
	song: one(songs, {
		fields: [songs_original_songs.song_id],
		references: [songs.id]
	}),
	original_song: one(original_songs, {
		fields: [songs_original_songs.original_song_id],
		references: [original_songs.id]
	}),
}));

export const songs_artist_rolesRelations = relations(songs_artist_roles, ({one}) => ({
	song: one(songs, {
		fields: [songs_artist_roles.song_id],
		references: [songs.id]
	}),
	artist_name: one(artist_names, {
		fields: [songs_artist_roles.artist_name_id],
		references: [artist_names.id]
	}),
	artist_role: one(artist_roles, {
		fields: [songs_artist_roles.artist_role_id],
		references: [artist_roles.id]
	}),
}));

export const artist_rolesRelations = relations(artist_roles, ({many}) => ({
	songs_artist_roles: many(songs_artist_roles),
}));

export const songs_genresRelations = relations(songs_genres, ({one}) => ({
	song: one(songs, {
		fields: [songs_genres.song_id],
		references: [songs.id]
	}),
	genre: one(genres, {
		fields: [songs_genres.genre_id],
		references: [genres.id]
	}),
}));

export const genresRelations = relations(genres, ({many}) => ({
	songs_genres: many(songs_genres),
	genreable_genres: many(genreable_genres),
}));

export const genreable_genresRelations = relations(genreable_genres, ({one}) => ({
	genre: one(genres, {
		fields: [genreable_genres.genre_id],
		references: [genres.id]
	}),
}));

export const taggingsRelations = relations(taggings, ({one}) => ({
	tag: one(tags, {
		fields: [taggings.tag_id],
		references: [tags.id]
	}),
}));

export const tagsRelations = relations(tags, ({many}) => ({
	taggings: many(taggings),
}));