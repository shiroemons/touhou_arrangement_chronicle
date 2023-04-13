package main

import (
	"context"
	"log"
	"os"

	"github.com/gocarina/gocsv"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistCSV struct {
	ArtistName string `csv:"artist_name"`
	ArtistType string `csv:"artist_type"`
}

func importArtists(ctx context.Context, db *bun.DB) {
	log.Println("start artists import.")

	f, err := os.Open("./tmp/artists.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []ArtistCSV
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var artists []entity.Artist
	for _, line := range lines {
		c := entity.Artist{
			Name: line.ArtistName,
		}
		artists = append(artists, c)
	}

	_, err = db.NewInsert().Model(&artists).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish artists import.")
}
