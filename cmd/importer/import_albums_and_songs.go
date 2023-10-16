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

	"github.com/samber/lo"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
	"golang.org/x/exp/slices"
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

	vocalTag, err := FindTagByName(imp.ctx, imp.db, "ボーカル有り")
	if err != nil {
		log.Fatal("error:", err)
	}
	tdmdTag, err := FindTagByName(imp.ctx, imp.db, "ボーカル有り")
	if err != nil {
		log.Fatal("error:", err)
	}

	albums := data["albums"]
	err = importAlbumsData(imp.ctx, imp.db, albums, vocalTag, tdmdTag)
	if err != nil {
		log.Fatal("error:", err)
	}

	log.Println("finish albums import.")
}

func importAlbumsData(ctx context.Context, db *bun.DB, albums []Album, vTag, tTag *schema.Tag) error {
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
			err = createAlbumTag(ctx, db, eAlbum, tTag)
			if err != nil {
				return err
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

			if len(track.Vocalists) > 0 {
				err = createAlbumTag(ctx, db, eAlbum, vTag)
				if err != nil {
					return err
				}

				err = createSongTag(ctx, db, song, vTag)
				if err != nil {
					return err
				}
			}
		}
	}
	return nil
}

func FindOrCreateAlbum(ctx context.Context, db *bun.DB, al Album) (*schema.Album, bool, error) {
	existing := new(schema.Album)
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

	var event *schema.Event
	if al.Event.Name != "" {
		event, err = FindEventByName(ctx, db, al.Event.Name)
		if err != nil {
			return nil, false, err
		}
	}

	album := &schema.Album{
		Name:              al.Name,
		ReleaseCircleName: al.Circle.Name,
		PublishedAt:       lo.ToPtr(time.Now()),
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

func FindEventByName(ctx context.Context, db *bun.DB, name string) (*schema.Event, error) {
	event := new(schema.Event)
	err := db.NewSelect().Model(event).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return event, nil
}

func createAlbumCirclesRelation(ctx context.Context, db *bun.DB, album *schema.Album, al Album) error {
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
			albumCircle := &schema.AlbumCircle{
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

	albumCircle := &schema.AlbumCircle{
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

func FindCircleByName(ctx context.Context, db *bun.DB, name string) (*schema.Circle, error) {
	circle := new(schema.Circle)
	err := db.NewSelect().Model(circle).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return circle, nil
}

func createAlbumDistributionServiceURL(ctx context.Context, db *bun.DB, album *schema.Album, link Link) error {
	albumDS := &schema.AlbumDistributionServiceURL{
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

func FindOrCreateSong(ctx context.Context, db *bun.DB, album *schema.Album, track Track) (*schema.Song, error) {
	existing := new(schema.Song)
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

	song := &schema.Song{
		Name:        track.Name,
		AlbumID:     album.ID,
		DiscNumber:  track.DiscNumber,
		TrackNumber: track.TrackNumber,
		ReleaseDate: album.ReleaseDate,
		PublishedAt: lo.ToPtr(time.Now()),
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

func createSongArtistRelations(ctx context.Context, db *bun.DB, song *schema.Song, track Track) error {
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
				songArtist := &schema.SongVocalist{
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
				songArtist := &schema.SongArranger{
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
				songArtist := &schema.SongLyricist{
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

	if len(song.Composers) == 0 && len(track.OriginalSongs) != 0 {
		var artists []string
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
				if oSong.ProductID != "0799" {
					artists = append(artists, oSong.Composer)
				}
			}
		}
		composers := slices.Compact(artists)
		for _, composer := range composers {
			if composer != "" {
				artist, err := FindArtistByName(ctx, db, composer)
				if err != nil {
					return err
				}
				if artist == nil {
					fmt.Println("Not Found composer artist:", composer)
					return nil
				}
				songArtist := &schema.SongComposer{
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

func FindArtistByName(ctx context.Context, db *bun.DB, name string) (*schema.Artist, error) {
	artist := new(schema.Artist)
	err := db.NewSelect().Model(artist).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return artist, nil
}

func createSongOriginalSongRelations(ctx context.Context, db *bun.DB, song *schema.Song, track Track) error {
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
				songOS := &schema.SongOriginalSong{
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

func FindOriginalSongByName(ctx context.Context, db *bun.DB, name string, isOriginal bool) (*schema.OriginalSong, error) {
	originalSong := new(schema.OriginalSong)
	err := db.NewSelect().Model(originalSong).Where("name = ? and is_original = ?", name, isOriginal).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return originalSong, nil
}

func FindTagByName(ctx context.Context, db *bun.DB, name string) (*schema.Tag, error) {
	event := new(schema.Tag)
	err := db.NewSelect().Model(event).Where("name = ?", name).Limit(1).Scan(ctx)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, err
	}
	return event, nil
}

func createAlbumTag(ctx context.Context, db *bun.DB, album *schema.Album, tag *schema.Tag) error {
	if album != nil && tag != nil {
		albumTag := &schema.AlbumTag{
			AlbumID: album.ID,
			TagID:   tag.ID,
		}
		_, err := db.NewInsert().
			Model(albumTag).
			Ignore().
			Exec(ctx)
		if err != nil {
			return err
		}
	}
	return nil
}

func createSongTag(ctx context.Context, db *bun.DB, song *schema.Song, tag *schema.Tag) error {
	if song != nil && tag != nil {
		songTag := &schema.SongTag{
			SongID: song.ID,
			TagID:  tag.ID,
		}
		_, err := db.NewInsert().
			Model(songTag).
			Ignore().
			Exec(ctx)
		if err != nil {
			return err
		}
	}
	return nil
}
