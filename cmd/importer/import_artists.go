package main

import (
	"database/sql"
	"errors"
	"log"
	"os"

	"github.com/gocarina/gocsv"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistCSV struct {
	ArtistName string `csv:"artist_name"`
	ArtistType string `csv:"artist_type"`
}

func (imp *Importer) importArtists() {
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
		artist := entity.Artist{}
		err = imp.db.NewSelect().Model(&artist).Where("name = ?", line.ArtistName).Limit(1).Scan(imp.ctx)
		if err != nil && errors.Is(err, sql.ErrNoRows) {
			c := entity.Artist{
				Name: line.ArtistName,
			}
			artists = append(artists, c)
		}
	}

	if len(artists) == 0 {
		return
	}

	_, err = imp.db.NewInsert().Model(&artists).
		Ignore().
		Exec(imp.ctx)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("finish artists import.")
}
