package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/gocarina/gocsv"
	"github.com/rs/xid"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
)

type ArtistCSV struct {
	ArtistName string `csv:"artist_name"`
	ArtistType string `csv:"artist_type"`
}

type Artist struct {
	bun.BaseModel `bun:"table:artists,alias:a"`

	ID                  string    `bun:",pk"`
	Name                string    `bun:"name,nullzero,notnull"`
	NameReading         string    `bun:"name_reading,nullzero,notnull,default:''"`
	InitialLetterType   string    `bun:"initial_letter_type,type:initial_letter_type,nullzero,notnull"`
	InitialLetterDetail string    `bun:"initial_letter_detail,notnull"`
	Description         string    `bun:"description,nullzero,notnull,default:''"`
	URL                 string    `bun:"url,nullzero,notnull,default:''"`
	BlogURL             string    `bun:"blog_url,nullzero,notnull,default:''"`
	TwitterURL          string    `bun:"twitter_url,nullzero,notnull,default:''"`
	YoutubeChannelURL   string    `bun:"youtube_channel_url,nullzero,notnull,default:''"`
	CreatedAt           time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt           time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Artist)(nil)

func (e *Artist) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
		if e.Name != "" {
			ilType, ilDetail := domain.InitialLetter(e.Name)
			e.InitialLetterType = string(ilType)
			e.InitialLetterDetail = ilDetail
		}
	case *bun.UpdateQuery:
		if e.Name != "" {
			ilType, ilDetail := domain.InitialLetter(e.Name)
			e.InitialLetterType = string(ilType)
			e.InitialLetterDetail = ilDetail
		}
	}
	return nil
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

	var artists []Artist
	for _, line := range lines {
		c := Artist{
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
