package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/k0kubun/pp/v3"
	"github.com/meilisearch/meilisearch-go"
	"github.com/samber/lo"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

const (
	limit = 10000
)

var ProductTypeMap = map[string]string{
	"pc98":                  "02. PC98作品",
	"windows":               "01. Windows作品",
	"zuns_music_collection": "03. ZUN's Music Collection",
	"akyus_untouched_score": "04. 幺樂団の歴史　～ Akyu's Untouched Score",
	"commercial_books":      "05. 商業書籍",
	"tasofro":               "06. 黄昏フロンティア作品",
	"other":                 "07. その他",
}

func setupSongs(ctx context.Context, db *bun.DB, cli *meilisearch.Client) {
	// An index is where the documents are stored.
	index := cli.Index("songs")
	offset := 0
	for {
		documents := getSongDocs(ctx, db, offset)

		task, err := index.AddDocuments(documents, "id")
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		pp.Println(task)
		if len(documents) < limit {
			break
		}
		offset += len(documents)
	}
}

func getSongDocs(ctx context.Context, db *bun.DB, offset int) []map[string]interface{} {
	var songs []schema.Song
	err := db.NewSelect().Model(&songs).
		Relation("Album").
		Relation("Album.Event").
		Relation("Album.AlbumDistributionServiceURLs").
		Relation("Album.Circles").
		Relation("SongDistributionServiceURLs").
		Relation("OriginalSongs").
		Relation("OriginalSongs.Product").
		Relation("Arrangers").
		Relation("Composers").
		Relation("Lyricists").
		Relation("ReArrangers").
		Relation("Vocalists").
		Relation("Genres").
		Relation("Genres.Genre").
		Relation("Tags").
		Relation("Tags.Tag").
		Where("s.published_at IS NOT NULL").
		Where("s.archived_at IS NULL").
		Offset(offset).
		Limit(limit).
		Scan(ctx)
	if err != nil {
		log.Fatal(err)
		return nil
	}

	var songDocs []map[string]interface{}
	for _, s := range songs {
		var eventName *string
		if s.Album.Event != nil {
			eventName = &s.Album.Event.Name
		}
		var releaseYear *int
		var releaseDate *string
		if s.ReleaseDate != nil {
			releaseYear = lo.ToPtr(s.ReleaseDate.Year())
			releaseDate = lo.ToPtr(s.ReleaseDate.Format("2006-01-02"))
		}
		var isTouhouArrange bool
		if s.OriginalSongs != nil {
			for _, oSong := range s.OriginalSongs {
				isTouhouArrange = oSong.ID != "07990001" && oSong.ID != "07990003"
				if isTouhouArrange {
					break
				}
			}
		}

		song := map[string]interface{}{
			"id":                  s.ID,
			"slug":                s.Slug,
			"name":                s.Name,
			"name_reading":        s.NameReading,
			"disc_number":         s.DiscNumber,
			"track_number":        s.TrackNumber,
			"album_name":          s.Album.Name,
			"album_name_reading":  s.Album.NameReading,
			"album_service_urls":  convertAlbumServiceUrlsToMaps(s.Album.AlbumDistributionServiceURLs),
			"circle_name":         s.Album.ReleaseCircleName,
			"circles":             convertCirclesToMaps(s.Album.Circles),
			"release_event_name":  eventName,
			"year":                releaseYear,
			"release_date":        releaseDate,
			"composers":           convertArtistsToMaps(s.Composers),
			"composer_count":      len(s.Composers),
			"arrangers":           convertArtistsToMaps(s.Arrangers),
			"arranger_count":      len(s.Arrangers),
			"rearrangers":         convertArtistsToMaps(s.ReArrangers),
			"rearranger_count":    len(s.ReArrangers),
			"lyricists":           convertArtistsToMaps(s.Lyricists),
			"lyricist_count":      len(s.Lyricists),
			"vocalists":           convertArtistsToMaps(s.Vocalists),
			"vocalist_count":      len(s.Vocalists),
			"original_songs":      convertOriginalSongsToMaps(s.OriginalSongs),
			"original_song_count": len(s.OriginalSongs),
			"is_touhou_arrange":   isTouhouArrange,
			"service_urls":        convertSongServiceUrlsToMaps(s.SongDistributionServiceURLs),
			"tags":                convertSongTags(s.Tags),
			"genres":              convertSongGenres(s.Genres),
		}
		songDocs = append(songDocs, song)
	}

	return songDocs
}

func convertCirclesToMaps(circles []*schema.Circle) []map[string]interface{} {
	if len(circles) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(circles))

	for i, circle := range circles {
		maps[i] = map[string]interface{}{
			"id":           circle.ID,
			"name":         circle.Name,
			"name_reading": circle.NameReading,
		}
	}

	return maps
}

func convertArtistsToMaps(artists []*schema.Artist) []map[string]interface{} {
	if len(artists) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(artists))

	for i, artist := range artists {
		maps[i] = map[string]interface{}{
			"id":           artist.ID,
			"name":         artist.Name,
			"name_reading": artist.NameReading,
		}
	}

	return maps
}

func convertOriginalSongsToMaps(originalSongs []*schema.OriginalSong) []map[string]interface{} {
	if len(originalSongs) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(originalSongs))

	for i, originalSong := range originalSongs {
		maps[i] = map[string]interface{}{
			"id":                 originalSong.ID,
			"name":               originalSong.Name,
			"lvl0":               generateLevel0(originalSong),
			"lvl1":               generateLevel1(originalSong),
			"lvl2":               generateLevel2(originalSong),
			"product_name":       originalSong.Product.Name,
			"product_short_name": originalSong.Product.ShortName,
		}
	}

	return maps
}

func generateLevel0(song *schema.OriginalSong) string {
	return ProductTypeMap[song.Product.ProductType]
}

func generateLevel1(song *schema.OriginalSong) string {
	return fmt.Sprintf("%s > %04.1f. %s", ProductTypeMap[song.Product.ProductType], song.Product.SeriesNumber, song.Product.ShortName)
}

func generateLevel2(song *schema.OriginalSong) string {
	return fmt.Sprintf("%s > %04.1f. %s > %02d. %s", ProductTypeMap[song.Product.ProductType], song.Product.SeriesNumber, song.Product.ShortName, song.TrackNumber, song.Name)
}

func convertAlbumServiceUrlsToMaps(serviceUrls []*schema.AlbumDistributionServiceURL) []map[string]interface{} {
	if len(serviceUrls) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(serviceUrls))

	for i, serviceUrl := range serviceUrls {
		maps[i] = map[string]interface{}{
			"id":      serviceUrl.ID,
			"service": serviceUrl.Service,
			"url":     serviceUrl.URL,
		}
	}

	return maps
}

func convertSongServiceUrlsToMaps(serviceUrls []*schema.SongDistributionServiceURL) []map[string]interface{} {
	if len(serviceUrls) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(serviceUrls))

	for i, serviceUrl := range serviceUrls {
		maps[i] = map[string]interface{}{
			"id":      serviceUrl.ID,
			"service": serviceUrl.Service,
			"url":     serviceUrl.URL,
		}
	}

	return maps
}

func convertSongTags(tags []*schema.SongTag) []map[string]interface{} {
	if len(tags) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(tags))
	for i, tag := range tags {
		maps[i] = map[string]interface{}{
			"id":   tag.ID,
			"name": tag.Tag.Name,
		}
	}
	return maps
}

func convertSongGenres(genres []*schema.SongGenre) []map[string]interface{} {
	if len(genres) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(genres))
	for i, genre := range genres {
		maps[i] = map[string]interface{}{
			"id":   genre.ID,
			"name": genre.Genre.Name,
		}
	}
	return maps
}
