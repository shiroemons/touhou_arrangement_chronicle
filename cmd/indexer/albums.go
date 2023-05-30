package main

import (
	"context"
	"fmt"
	"os"

	"github.com/k0kubun/pp/v3"
	"github.com/meilisearch/meilisearch-go"
	"github.com/samber/lo"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

func setupAlbums(ctx context.Context, db *bun.DB, cli *meilisearch.Client) {
	// An index is where the documents are stored.
	index := cli.Index("albums")
	documents := getAlbumDocs(ctx, db)

	task, err := index.AddDocuments(documents, "id")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	pp.Println(task)
}

func getAlbumDocs(ctx context.Context, db *bun.DB) []map[string]interface{} {
	var documents []map[string]interface{}
	albums := getAlbums(ctx, db)
	for _, album := range albums {
		doc := albumDocConverter(album)
		documents = append(documents, doc)
	}

	return documents
}

func getAlbums(ctx context.Context, db *bun.DB) []*entity.Album {
	albums := make([]*entity.Album, 0)
	err := db.NewSelect().Model(&albums).
		Relation("Event").
		Relation("SubEvent").
		Relation("Tags").
		Relation("Tags.Tag").
		Relation("Genres").
		Relation("Genres.Genre").
		Relation("Circles").
		Relation("AlbumDistributionServiceURLs").
		Where("al.search_enabled = ?", true).
		Order("al.id ASC").
		Scan(ctx)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return albums
}

func albumDocConverter(album *entity.Album) map[string]interface{} {
	var serviceURLs []map[string]interface{}
	if album.AlbumDistributionServiceURLs != nil {
		for _, dsu := range album.AlbumDistributionServiceURLs {
			serviceURLs = append(serviceURLs, map[string]interface{}{
				"name": dsu.Service,
				"url":  dsu.URL,
			})
		}
	}

	var eventName *string
	if album.Event != nil {
		eventName = &album.Event.Name
	}

	var releaseYear *int
	var releaseDate *string
	if album.ReleaseDate != nil {
		releaseYear = lo.ToPtr(album.ReleaseDate.Year())
		releaseDate = lo.ToPtr(album.ReleaseDate.Format("2006-01-02"))
	}

	return map[string]interface{}{
		"id":                  album.ID,
		"slug":                album.Slug,
		"release_circle_name": album.ReleaseCircleName,
		"name":                album.Name,
		"event_name":          eventName,
		"year":                releaseYear,
		"release_date":        releaseDate,
		"service_urls":        serviceURLs,
		"tags":                convertAlbumTags(album.Tags),
		"genres":              convertAlbumGenres(album.Genres),
	}
}

func convertAlbumTags(tags []*entity.AlbumTag) []map[string]interface{} {
	if len(tags) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(tags))
	for i, tag := range tags {
		maps[i] = map[string]interface{}{
			"id":   tag.ID,
			"name": tag.Tag.Name,
		}
	}
	return maps
}

func convertAlbumGenres(genres []*entity.AlbumGenre) []map[string]interface{} {
	if len(genres) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(genres))
	for i, genre := range genres {
		maps[i] = map[string]interface{}{
			"id":   genre.ID,
			"name": genre.Genre.Name,
		}
	}
	return maps
}
