package main

import (
	"context"
	"fmt"
	"os"

	"github.com/meilisearch/meilisearch-go"

	"github.com/shiroemons/touhou_arrangement_chronicle/pkg/entity"
	"github.com/shiroemons/touhou_arrangement_chronicle/pkg/infra/store"
	"github.com/shiroemons/touhou_arrangement_chronicle/pkg/repository"
)

func main() {
	client := meilisearch.NewClient(meilisearch.ClientConfig{
		Host:   "http://127.0.0.1:17700",
		APIKey: "MASTER_KEY",
	})
	// An index is where the documents are stored.
	index := client.Index("original_songs")

	documents := getOriginalSongs()

	task, err := index.AddDocuments(documents)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(task.TaskUID)
}

func getOriginalSongs() []map[string]interface{} {
	var documents []map[string]interface{}
	songs := originalSongs()
	for _, song := range songs {
		doc := convert(song)
		documents = append(documents, doc)
	}

	return documents
}

func originalSongs() []*entity.OriginalSong {
	ctx := context.Background()
	db := store.NewDB("postgres://postgres:@127.0.0.1:15432/touhou_arrangement_chronicle_development?sslmode=disable")
	osRepo := repository.NewOriginalSong(db)
	songs, err := osRepo.All(ctx)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return songs
}

func convert(song *entity.OriginalSong) map[string]interface{} {
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
