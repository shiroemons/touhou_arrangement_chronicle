package main

import (
	"log"
	"os"

	"github.com/gocarina/gocsv"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumServiceUrlTSV struct {
	Jan                 string `csv:"jan"`
	Circle              string `csv:"circle"`
	SpotifyAlbumName    string `csv:"spotify_album_name"`
	SpotifyAlbumUrl     string `csv:"spotify_album_url"`
	AppleMusicAlbumName string `csv:"apple_music_album_name"`
	AppleMusicAlbumUrl  string `csv:"apple_music_album_url"`
	YTMusicAlbumName    string `csv:"ytmusic_album_name"`
	YTMusicAlbumUrl     string `csv:"ytmusic_album_url"`
	LineMusicAlbumName  string `csv:"line_music_album_name"`
	LineMusicAlbumUrl   string `csv:"line_music_album_url"`
}

func (imp *Importer) importAlbumServiceUrl() {
	log.Println("start album service url import.")

	f, err := os.OpenFile("./tmp/touhou_music_album_only.tsv", os.O_RDWR|os.O_CREATE, os.ModePerm)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var albums []*AlbumServiceUrlTSV

	if err = gocsv.UnmarshalFile(f, &albums); err != nil {
		log.Fatal(err)
	}

	for _, album := range albums {
		appleMusic := imp.findByAppleMusicUrl(album.AppleMusicAlbumUrl)
		if appleMusic == nil {
			continue
		}
		if album.SpotifyAlbumUrl != "" {
			spotify := entity.AlbumDistributionServiceURL{
				AlbumID: appleMusic.AlbumID,
				Service: "spotify",
				URL:     album.SpotifyAlbumUrl,
			}
			err = imp.createAlbumServiceUrl(spotify)
			if err != nil {
				log.Fatal(err)
			}
		}
		if album.YTMusicAlbumUrl != "" {
			ytmusic := entity.AlbumDistributionServiceURL{
				AlbumID: appleMusic.AlbumID,
				Service: "youtube_music",
				URL:     album.YTMusicAlbumUrl,
			}
			err = imp.createAlbumServiceUrl(ytmusic)
			if err != nil {
				log.Fatal(err)
			}
		}
		if album.LineMusicAlbumUrl != "" {
			lineMusic := entity.AlbumDistributionServiceURL{
				AlbumID: appleMusic.AlbumID,
				Service: "line_music",
				URL:     album.LineMusicAlbumUrl,
			}
			err = imp.createAlbumServiceUrl(lineMusic)
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	log.Println("finish album service url import.")
}

func (imp *Importer) findByAppleMusicUrl(url string) *entity.AlbumDistributionServiceURL {
	existing := new(entity.AlbumDistributionServiceURL)
	err := imp.db.NewSelect().
		Model(existing).
		Where("url = ?", url).
		Limit(1).
		Scan(imp.ctx)
	if err != nil {
		return nil
	}
	return existing
}

func (imp *Importer) createAlbumServiceUrl(adsu entity.AlbumDistributionServiceURL) error {
	_, err := imp.db.NewInsert().Model(&adsu).
		Ignore().
		Exec(imp.ctx)
	if err != nil {
		return err
	}
	return nil
}
