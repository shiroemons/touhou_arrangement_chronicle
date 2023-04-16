package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/k0kubun/pp/v3"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type Album struct {
	Name          string  `json:"name"`
	Circle        Circle  `json:"circle"`
	Event         Event   `json:"event"`
	ReleaseDate   string  `json:"release_date"`
	Tracks        []Track `json:"tracks"`
	ExternalLinks []Link  `json:"external_links"`
}

type Circle struct {
	Name          string `json:"name"`
	ExternalLinks []Link `json:"external_links"`
}

type Event struct {
	Name        string      `json:"name"`
	EventSeries EventSeries `json:"event_series"`
	StartDate   string      `json:"start_date"`
	EndDate     string      `json:"end_date"`
}

type EventSeries struct {
	Name string `json:"name"`
}

type Track struct {
	Name          string   `json:"name"`
	DiscNumber    int      `json:"disc_number"`
	TrackNumber   int      `json:"track_number"`
	Vocalists     []Artist `json:"vocalists"`
	Arrangers     []Artist `json:"arrangers"`
	Lyricists     []Artist `json:"lyricists"`
	OriginalSongs []Song   `json:"original_songs"`
}

type Artist struct {
	Name string `json:"name"`
}

type Song struct {
	Title string `json:"title"`
}

type Link struct {
	Label string `json:"label"`
	Type  string `json:"type"`
	URL   string `json:"url"`
}

func importAlbums(ctx context.Context, db *bun.DB) {
	log.Println("start albums import.")

	jsonFile, err := os.ReadFile("./tmp/albums.json")
	if err != nil {
		fmt.Println("error:", err)
		os.Exit(1)
	}

	var data map[string][]Album
	err = json.Unmarshal(jsonFile, &data)
	if err != nil {
		fmt.Println("error:", err)
		os.Exit(1)
	}

	albums := data["albums"]
	err = importAlbum(ctx, db, albums)
	if err != nil {
		fmt.Println("error:", err)
		os.Exit(1)
	}

	log.Println("finish albums import.")
}

func importAlbum(ctx context.Context, db *bun.DB, albums []Album) error {
	for _, album := range albums {
		if album.Event.Name != "" {
			event, err := EventFindByName(ctx, db, album.Event.Name)
			if err != nil {
				return err
			}
			pp.Println(event)
		}

		fmt.Println("Album:", album.Name)
		fmt.Println("Circle:", album.Circle.Name)
		fmt.Println("Event:", album.Event.Name)
		fmt.Println("Release Date:", album.ReleaseDate)

		for _, track := range album.Tracks {
			fmt.Println("Track:", track.Name)
			fmt.Println("Vocalists:")
			for _, vocalist := range track.Vocalists {
				fmt.Println("  -", vocalist.Name)
			}
			fmt.Println("Arrangers:")
			for _, arranger := range track.Arrangers {
				fmt.Println("  -", arranger.Name)
			}
			fmt.Println("Lyricists:")
			for _, lyricist := range track.Lyricists {
				fmt.Println("  -", lyricist.Name)
			}
			fmt.Println("Original Songs:")
			for _, originalSong := range track.OriginalSongs {
				fmt.Println("  -", originalSong.Title)
			}
		}
		break
	}
	return nil
}

func EventFindByName(ctx context.Context, db *bun.DB, name string) (*entity.Event, error) {
	event := new(entity.Event)
	err := db.NewSelect().Model(event).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		return nil, err
	}
	return event, nil
}
