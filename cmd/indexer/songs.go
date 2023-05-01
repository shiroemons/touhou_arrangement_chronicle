package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/k0kubun/pp/v3"
	"github.com/meilisearch/meilisearch-go"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
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
	var songs []entity.Song
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
		Relation("GenreTags").
		Relation("Tags").
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
			year := s.ReleaseDate.Year()
			releaseYear = &year
			date := s.ReleaseDate.Format("2006-01-02")
			releaseDate = &date
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
			"name":                s.Name,
			"disc_number":         s.DiscNumber,
			"track_number":        s.TrackNumber,
			"album_name":          s.Album.Name,
			"album_service_urls":  convertAlbumServiceUrlsToMaps(s.Album.AlbumDistributionServiceURLs),
			"circle_name":         s.Album.ReleaseCircleName,
			"circles":             convertCirclesToMaps(s.Album.Circles),
			"release_event_name":  eventName,
			"release_year":        releaseYear,
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
			"tags":                convertTags(s.Tags),
			"genre_tags":          convertTags(s.GenreTags),
		}
		songDocs = append(songDocs, song)
	}

	return songDocs
}

func convertCirclesToMaps(circles []*entity.Circle) []map[string]interface{} {
	if len(circles) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(circles))

	for i, circle := range circles {
		maps[i] = map[string]interface{}{
			"id":   circle.ID,
			"name": circle.Name,
		}
	}

	return maps
}

func convertArtistsToMaps(artists []*entity.Artist) []map[string]interface{} {
	if len(artists) == 0 {
		return nil
	}
	maps := make([]map[string]interface{}, len(artists))

	for i, artist := range artists {
		maps[i] = map[string]interface{}{
			"id":   artist.ID,
			"name": artist.Name,
		}
	}

	return maps
}

func convertOriginalSongsToMaps(originalSongs []*entity.OriginalSong) []map[string]interface{} {
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

func generateLevel0(song *entity.OriginalSong) string {
	return ProductTypeMap[song.Product.ProductType]
}

func generateLevel1(song *entity.OriginalSong) string {
	return fmt.Sprintf("%s > %04.1f. %s", ProductTypeMap[song.Product.ProductType], song.Product.SeriesNumber, song.Product.ShortName)
}

func generateLevel2(song *entity.OriginalSong) string {
	return fmt.Sprintf("%s > %04.1f. %s > %02d. %s", ProductTypeMap[song.Product.ProductType], song.Product.SeriesNumber, song.Product.ShortName, song.TrackNumber, song.Name)
}

func convertAlbumServiceUrlsToMaps(serviceUrls []*entity.AlbumDistributionServiceURL) []map[string]interface{} {
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

func convertSongServiceUrlsToMaps(serviceUrls []*entity.SongDistributionServiceURL) []map[string]interface{} {
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

func convertTags(tags []*entity.Tag) []string {
	if len(tags) == 0 {
		return nil
	}
	arr := make([]string, len(tags))
	for i, tag := range tags {
		arr[i] = tag.Name
	}
	return arr
}
