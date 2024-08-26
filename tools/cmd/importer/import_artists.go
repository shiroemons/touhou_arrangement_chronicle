package main

import (
	"database/sql"
	"errors"
	"log"
	"os"
	"time"

	"github.com/gocarina/gocsv"
	"github.com/samber/lo"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type ArtistCSV struct {
	ArtistName string `csv:"artist_name"`
	ArtistType string `csv:"artist_type"`
}

func (imp *Importer) importArtists() {
	log.Println("start artists import.")

	f, err := os.Open("../tmp/artists.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []ArtistCSV
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var artists []schema.Artist
	for _, line := range lines {
		artist := schema.Artist{}
		err = imp.db.NewSelect().Model(&artist).Where("name = ?", line.ArtistName).Limit(1).Scan(imp.ctx)
		if err != nil && errors.Is(err, sql.ErrNoRows) {
			c := schema.Artist{
				Name:        line.ArtistName,
				PublishedAt: lo.ToPtr(time.Now()),
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
