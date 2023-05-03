package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

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

func (imp *Importer) importAlbums() {
	log.Println("start albums import.")

	jsonFile, err := os.ReadFile("./tmp/albums.json")
	if err != nil {
		log.Fatal("error:", err)
	}

	var data map[string][]Album
	err = json.Unmarshal(jsonFile, &data)
	if err != nil {
		log.Fatal("error:", err)
	}

	albums := data["albums"]
	err = importAlbumsData(imp.ctx, imp.db, albums)
	if err != nil {
		log.Fatal("error:", err)
	}

	log.Println("finish albums import.")
}

func importAlbumsData(ctx context.Context, db *bun.DB, albums []Album) error {
	if len(albums) == 0 {
		return nil
	}

	for _, album := range albums {
		eAlbum, exist, err := FindOrCreateAlbum(ctx, db, album)
		if err != nil {
			return err
		}
		if exist {
			continue
		}

		if len(eAlbum.Circles) == 0 {
			err = createAlbumCirclesRelation(ctx, db, eAlbum, album)
			if err != nil {
				return err
			}
		}

		if len(eAlbum.AlbumDistributionServiceURLs) != len(album.ExternalLinks) {
			for _, link := range album.ExternalLinks {
				err = createAlbumDistributionServiceURL(ctx, db, eAlbum, link)
				if err != nil {
					return err
				}
			}
		}

		for _, track := range album.Tracks {
			song, err := FindOrCreateSong(ctx, db, eAlbum, track)
			if err != nil {
				return err
			}

			err = createSongArtistRelations(ctx, db, song, track)
			if err != nil {
				return err
			}

			err = createSongOriginalSongRelations(ctx, db, song, track)
			if err != nil {
				return err
			}
		}
	}
	return nil
}

func FindOrCreateAlbum(ctx context.Context, db *bun.DB, al Album) (*entity.Album, bool, error) {
	existing := new(entity.Album)
	err := db.NewSelect().
		Model(existing).
		Relation("Circles").
		Relation("AlbumDistributionServiceURLs").
		Where("name = ?", al.Name).
		Where("release_circle_name = ?", al.Circle.Name).
		WhereGroup(" AND ", func(q *bun.SelectQuery) *bun.SelectQuery {
			if al.ReleaseDate != "" {
				return q.Where("release_date = ?", al.ReleaseDate)
			}
			return q.Where("release_date is null")
		}).
		Limit(1).
		Scan(ctx)
	if err == nil {
		return existing, true, nil
	}
	if err != sql.ErrNoRows {
		return nil, false, err
	}

	var event *entity.Event
	if al.Event.Name != "" {
		event, err = FindEventByName(ctx, db, al.Event.Name)
		if err != nil {
			return nil, false, err
		}
	}

	album := &entity.Album{
		Name:              al.Name,
		ReleaseCircleName: al.Circle.Name,
	}
	if al.ReleaseDate != "" {
		parsedTime, err := time.Parse("2006-01-02", al.ReleaseDate)
		if err != nil {
			fmt.Println("error:", err)
			return nil, false, err
		}
		album.ReleaseDate = &parsedTime
	}

	if event != nil {
		album.EventID = event.ID
	}
	_, err = db.NewInsert().
		Model(album).
		Ignore().
		Exec(ctx)

	if err != nil {
		return nil, false, err
	}

	return album, false, nil
}

func FindEventByName(ctx context.Context, db *bun.DB, name string) (*entity.Event, error) {
	event := new(entity.Event)
	err := db.NewSelect().Model(event).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return event, nil
}

func createAlbumCirclesRelation(ctx context.Context, db *bun.DB, album *entity.Album, al Album) error {
	circle, err := FindCircleByName(ctx, db, al.Circle.Name)
	if err != nil {
		return err
	}
	if circle == nil {
		splitted := strings.Split(al.Circle.Name, "×")
		// 分割された文字列をトリムして結果のスライスに追加
		var result []string
		for _, s := range splitted {
			result = append(result, strings.TrimSpace(s))
		}
		if len(result) == 0 {
			fmt.Println("Not Found circle:", al.Circle.Name)
			return nil
		}

		for _, name := range result {
			circle, err = FindCircleByName(ctx, db, name)
			if err != nil {
				return err
			}
			if circle == nil {
				fmt.Println("Not Found circle:", name)
				continue
			}
			albumCircle := &entity.AlbumCircle{
				AlbumID:  album.ID,
				CircleID: circle.ID,
			}

			_, err = db.NewInsert().
				Model(albumCircle).
				Ignore().
				Exec(ctx)
			if err != nil {
				return err
			}
		}
		return nil
	}

	albumCircle := &entity.AlbumCircle{
		AlbumID:  album.ID,
		CircleID: circle.ID,
	}

	_, err = db.NewInsert().
		Model(albumCircle).
		Ignore().
		Exec(ctx)
	if err != nil {
		return err
	}

	return nil
}

func FindCircleByName(ctx context.Context, db *bun.DB, name string) (*entity.Circle, error) {
	circle := new(entity.Circle)
	err := db.NewSelect().Model(circle).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return circle, nil
}

func createAlbumDistributionServiceURL(ctx context.Context, db *bun.DB, album *entity.Album, link Link) error {
	albumDS := &entity.AlbumDistributionServiceURL{
		AlbumID: album.ID,
		Service: link.Label,
		URL:     link.URL,
	}

	_, err := db.NewInsert().
		Model(albumDS).
		Ignore().
		Exec(ctx)
	if err != nil {
		return err
	}
	return nil
}

func FindOrCreateSong(ctx context.Context, db *bun.DB, album *entity.Album, track Track) (*entity.Song, error) {
	existing := new(entity.Song)
	err := db.NewSelect().
		Model(existing).
		Relation("OriginalSongs").
		Relation("Arrangers").
		Relation("Composers").
		Relation("Lyricists").
		Relation("ReArrangers").
		Relation("Vocalists").
		Where("name = ?", track.Name).
		Where("album_id = ?", album.ID).
		Where("disc_number = ?", track.DiscNumber).
		Where("track_number = ?", track.TrackNumber).
		Limit(1).
		Scan(ctx)
	if err == nil {
		return existing, nil
	}
	if err != sql.ErrNoRows {
		return nil, err
	}

	song := &entity.Song{
		Name:        track.Name,
		AlbumID:     album.ID,
		DiscNumber:  track.DiscNumber,
		TrackNumber: track.TrackNumber,
		ReleaseDate: album.ReleaseDate,
	}

	_, err = db.NewInsert().
		Model(song).
		Ignore().
		Exec(ctx)

	if err != nil {
		return nil, err
	}

	return song, nil
}

func createSongArtistRelations(ctx context.Context, db *bun.DB, song *entity.Song, track Track) error {
	if len(song.Vocalists) != len(track.Vocalists) {
		for _, vocalist := range track.Vocalists {
			if vocalist.Name != "" {
				artist, err := FindArtistByName(ctx, db, vocalist.Name)
				if err != nil {
					return err
				}
				if artist == nil {
					fmt.Println("Not Found vocalist artist:", vocalist.Name)
					return nil
				}
				songArtist := &entity.SongVocalist{
					SongID:   song.ID,
					ArtistID: artist.ID,
				}
				_, err = db.NewInsert().
					Model(songArtist).
					Ignore().
					Exec(ctx)
				if err != nil {
					return err
				}
			}
		}
	}

	if len(song.Arrangers) != len(track.Arrangers) {
		for _, arranger := range track.Arrangers {
			if arranger.Name != "" {
				artist, err := FindArtistByName(ctx, db, arranger.Name)
				if err != nil {
					return err
				}
				if artist == nil {
					fmt.Println("Not Found arranger artist:", arranger.Name)
					return nil
				}
				songArtist := &entity.SongArranger{
					SongID:   song.ID,
					ArtistID: artist.ID,
				}
				_, err = db.NewInsert().
					Model(songArtist).
					Ignore().
					Exec(ctx)
				if err != nil {
					return err
				}
			}
		}
	}

	if len(song.Lyricists) != len(track.Lyricists) {
		for _, lyricist := range track.Lyricists {
			if lyricist.Name != "" {
				artist, err := FindArtistByName(ctx, db, lyricist.Name)
				if err != nil {
					return err
				}
				if artist == nil {
					fmt.Println("Not Found lyricist artist:", lyricist.Name)
					return nil
				}
				songArtist := &entity.SongLyricist{
					SongID:   song.ID,
					ArtistID: artist.ID,
				}
				_, err = db.NewInsert().
					Model(songArtist).
					Ignore().
					Exec(ctx)
				if err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func FindArtistByName(ctx context.Context, db *bun.DB, name string) (*entity.Artist, error) {
	artist := new(entity.Artist)
	err := db.NewSelect().Model(artist).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return artist, nil
}

func createSongOriginalSongRelations(ctx context.Context, db *bun.DB, song *entity.Song, track Track) error {
	if len(song.OriginalSongs) != len(track.OriginalSongs) {
		for _, originalSong := range track.OriginalSongs {
			if originalSong.Title != "" {
				title := originalSong.Title
				if originalSong.Title == "夜の鳩山を飛ぶ-Power Mix" {
					title = "夜の鳩山を飛ぶ‐Power Mix"
				} else if originalSong.Title == "アンノウンX　～ Occultly Madness" {
					title = "アンノウンＸ　～ Occultly Madness"
				}

				oSong, err := FindOriginalSongByName(ctx, db, title, true)
				if err != nil {
					return err
				}
				if oSong == nil {
					oSong, err = FindOriginalSongByName(ctx, db, title, false)
					if err != nil {
						return err
					}
					if oSong == nil {
						fmt.Println("Not Found Original Song:", originalSong.Title)
						return nil
					}
				}
				songOS := &entity.SongOriginalSong{
					SongID:         song.ID,
					OriginalSongID: oSong.ID,
				}
				_, err = db.NewInsert().
					Model(songOS).
					Ignore().
					Exec(ctx)
				if err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func FindOriginalSongByName(ctx context.Context, db *bun.DB, name string, isOriginal bool) (*entity.OriginalSong, error) {
	originalSong := new(entity.OriginalSong)
	err := db.NewSelect().Model(originalSong).Where("name = ? and is_original = ?", name, isOriginal).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return originalSong, nil
}
