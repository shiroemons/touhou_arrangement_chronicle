package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/k0kubun/pp/v3"
	"github.com/meilisearch/meilisearch-go"
	"github.com/uptrace/bun"
)

type OriginalSong struct {
	bun.BaseModel `bun:"table:original_songs,alias:os"`

	ID                                  string                                `bun:",pk"`
	ProductID                           string                                `bun:"product_id,nullzero,notnull"`
	Product                             Product                               `bun:"rel:belongs-to,join:product_id=id"`
	Name                                string                                `bun:"name,nullzero,notnull"`
	Composer                            string                                `bun:"composer,nullzero,notnull,default:''"`
	Arranger                            string                                `bun:"arranger,nullzero,notnull,default:''"`
	TrackNumber                         int                                   `bun:"track_number,nullzero,notnull"`
	Original                            bool                                  `bun:"is_original,notnull"`
	SourceID                            string                                `bun:"source_id,nullzero,notnull,default:''"`
	OriginalSongDistributionServiceURLs []*OriginalSongDistributionServiceURL `bun:"rel:has-many,join:id=original_song_id"`
	CreatedAt                           time.Time                             `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                           time.Time                             `bun:"updated_at,notnull,default:current_timestamp"`
}

type Product struct {
	bun.BaseModel `bun:"table:products,alias:p"`

	ID                             string                           `bun:",pk"`
	Name                           string                           `bun:"name,nullzero,notnull"`
	ShortName                      string                           `bun:"short_name,nullzero,notnull"`
	ProductType                    string                           `bun:"product_type,nullzero,notnull"`
	SeriesNumber                   float64                          `bun:"series_number,nullzero,notnull"`
	ProductDistributionServiceURLs []*ProductDistributionServiceURL `bun:"rel:has-many,join:id=product_id"`
	CreatedAt                      time.Time                        `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                      time.Time                        `bun:"updated_at,notnull,default:current_timestamp"`
}

type ProductDistributionServiceURL struct {
	bun.BaseModel `bun:"table:product_distribution_service_urls,alias:pdsu"`

	ID        string    `bun:",pk"`
	ProductID string    `bun:"product_id,nullzero,notnull"`
	Service   string    `bun:"service,nullzero,notnull"`
	URL       string    `bun:"url,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

type OriginalSongDistributionServiceURL struct {
	bun.BaseModel `bun:"table:original_song_distribution_service_urls,alias:osdsu"`

	ID             string    `bun:",pk"`
	OriginalSongID string    `bun:"original_song_id,nullzero,notnull"`
	Service        string    `bun:"service,nullzero,notnull"`
	URL            string    `bun:"url,nullzero,notnull"`
	CreatedAt      time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

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

func getOriginalSongs(ctx context.Context, db *bun.DB) []*OriginalSong {
	originalSongs := make([]*OriginalSong, 0)
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

func osDocConverter(song *OriginalSong) map[string]interface{} {
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
