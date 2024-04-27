package main

import (
	"context"
	"fmt"
	"os"

	"github.com/k0kubun/pp/v3"
	"github.com/meilisearch/meilisearch-go"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

func setupOriginalSongs(ctx context.Context, db *bun.DB, cli *meilisearch.Client) {
	// An index is where the documents are stored.
	index := cli.Index("original_songs")
	documents := getOriginalSongDocs(ctx, db)

	task, err := index.AddDocuments(documents, "id")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	pp.Println(task)
}

func getOriginalSongDocs(ctx context.Context, db *bun.DB) []map[string]interface{} {
	var documents []map[string]interface{}
	songs := getOriginalSongs(ctx, db)
	for _, song := range songs {
		doc := osDocConverter(song)
		documents = append(documents, doc)
	}

	return documents
}

func getOriginalSongs(ctx context.Context, db *bun.DB) []*schema.OriginalSong {
	originalSongs := make([]*schema.OriginalSong, 0)
	err := db.NewSelect().Model(&originalSongs).
		Relation("Product").
		Relation("Product.ProductDistributionServiceURLs").
		Relation("OriginalSongDistributionServiceURLs").
		Order("id ASC").
		Scan(ctx)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return originalSongs
}

func osDocConverter(song *schema.OriginalSong) map[string]interface{} {
	var pServiceURLs []map[string]interface{}
	if song.Product.ProductDistributionServiceURLs != nil {
		for _, pdsu := range song.Product.ProductDistributionServiceURLs {
			pServiceURLs = append(pServiceURLs, map[string]interface{}{
				"name": pdsu.Service,
				"url":  pdsu.URL,
			})
		}
	}

	var osServiceURLs []map[string]interface{}
	if song.OriginalSongDistributionServiceURLs != nil {
		for _, osdsu := range song.OriginalSongDistributionServiceURLs {
			osServiceURLs = append(osServiceURLs, map[string]interface{}{
				"name": osdsu.Service,
				"url":  osdsu.URL,
			})
		}
	}

	doc := map[string]interface{}{
		"id":           song.ID,
		"product_name": song.Product.Name,
		"name":         song.Name,
		"composer":     song.Composer,
		"arranger":     song.Arranger,
		"track_number": song.TrackNumber,
		"original":     song.Original,
		"source_id":    song.SourceID,
		"service_urls": osServiceURLs,
		"product": map[string]interface{}{
			"name":          song.Product.Name,
			"short_name":    song.Product.ShortName,
			"type":          song.Product.ProductType,
			"series_number": song.Product.SeriesNumber,
			"service_urls":  pServiceURLs,
		},
	}

	return doc
}
