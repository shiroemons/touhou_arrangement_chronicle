package main

import (
	"log"

	"github.com/meilisearch/meilisearch-go"
)

func setup(cli *meilisearch.Client) {
	settings := meilisearch.Settings{
		DisplayedAttributes: []string{
			"name",
			"album_name",
			"album_service_urls.service",
			"album_service_urls.url",
			"circle_name",
			"circles.name",
			"disc_number",
			"track_number",
			"release_year",
			"release_date",
			"release_event_name",
			"is_touhou_arrange",
			"arranger_count",
			"arrangers.name",
			"composer_count",
			"composers.name",
			"rearranger_count",
			"rearrangers.name",
			"lyricist_count",
			"lyricists.name",
			"vocalist_count",
			"vocalists.name",
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
			"album_name",
			"circle_name",
			"circles.name",
			"composers.name",
			"arrangers.name",
			"lyricists.name",
			"vocalists.name",
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
