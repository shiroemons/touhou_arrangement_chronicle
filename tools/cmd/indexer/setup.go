package main

import (
	"log"

	"github.com/meilisearch/meilisearch-go"
)

func setup(cli *meilisearch.Client) {
	settings := meilisearch.Settings{
		DisplayedAttributes: []string{
			"name",
			"name_reading",
			"album_name",
			"album_name_reading",
			"album_service_urls.service",
			"album_service_urls.url",
			"circle_name",
			"circles.name",
			"circles.name_reading",
			"disc_number",
			"track_number",
			"release_year",
			"release_date",
			"release_event_name",
			"is_touhou_arrange",
			"arranger_count",
			"arrangers.name",
			"arrangers.name_reading",
			"composer_count",
			"composers.name",
			"composers.name_reading",
			"rearranger_count",
			"rearrangers.name",
			"rearrangers.name_reading",
			"lyricist_count",
			"lyricists.name",
			"lyricists.name_reading",
			"vocalist_count",
			"vocalists.name",
			"vocalists.name_reading",
			"original_songs.name",
			"original_songs.lvl0",
			"original_songs.lvl1",
			"original_songs.lvl2",
			"original_songs.product_name",
			"original_songs.product_short_name",
			"original_song_count",
			"tags.name",
			"genres.name",
		},
		SearchableAttributes: []string{
			"name",
			"name_reading",
			"album_name",
			"album_name_reading",
			"circle_name",
			"circles.name",
			"circles.name_reading",
			"composers.name",
			"composers.name_reading",
			"arrangers.name",
			"arrangers.name_reading",
			"lyricists.name",
			"lyricists.name_reading",
			"vocalists.name",
			"vocalists.name_reading",
			"original_songs.name",
			"original_song_count",
			"tags.name",
			"genres.name",
			"release_year",
			"release_date",
			"release_event_name",
			"is_touhou_arrange",
		},
		FilterableAttributes: []string{
			"album_name",
			"circle_name",
			"circles.name",
			"composers.name",
			"arrangers.name",
			"lyricists.name",
			"vocalists.name",
			"original_songs.name",
			"original_songs.lvl0",
			"original_songs.lvl1",
			"original_songs.lvl2",
			"original_song_count",
			"tags.name",
			"genres.name",
			"release_year",
			"release_date",
			"release_event_name",
			"is_touhou_arrange",
		},
	}
	_, err := cli.Index("songs").UpdateSettings(&settings)
	if err != nil {
		log.Fatal(err)
	}
}