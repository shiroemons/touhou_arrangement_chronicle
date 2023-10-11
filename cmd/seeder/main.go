package main

import (
	"context"
	"encoding/csv"
	"io"
	"log"
	"os"

	"github.com/gocarina/gocsv"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/stdlib"
	"github.com/lucsky/cuid"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/spkg/bom"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/extra/bundebug"
)

type Product struct {
	bun.BaseModel `bun:"table:products,alias:p"`

	ID           string  `csv:"id" bun:",pk"`
	Name         string  `csv:"name" bun:"name,nullzero,notnull"`
	ShortName    string  `csv:"short_name" bun:"short_name,nullzero,notnull"`
	ProductType  string  `csv:"product_type" bun:"product_type,nullzero,notnull"`
	SeriesNumber float64 `csv:"series_number" bun:"series_number,nullzero,notnull"`
}

type OriginalSong struct {
	bun.BaseModel `bun:"table:original_songs,alias:os"`

	ID          string `csv:"id" bun:",pk"`
	ProductID   string `csv:"product_id" bun:"product_id,nullzero,notnull"`
	TrackNumber int    `csv:"track_number" bun:"track_number,nullzero,notnull"`
	Name        string `csv:"name" bun:"name,nullzero,notnull"`
	Composer    string `csv:"composer" bun:"composer,nullzero,notnull,default:''"`
	Arranger    string `csv:"arranger" bun:"arranger,nullzero,notnull,default:''"`
	SourceID    string `csv:"source_id" bun:"source_id,nullzero,notnull,default:''"`
	Original    bool   `csv:"is_original" bun:"is_original,notnull"`
}

type ProductDistributionServiceUrl struct {
	bun.BaseModel `bun:"table:product_distribution_service_urls,alias:pdsu"`

	ID        string `bun:",pk"`
	ProductID string `bun:"product_id,nullzero,notnull"`
	Service   string `bun:"service,nullzero,notnull"`
	URL       string `bun:"url,nullzero,notnull"`
}

type OriginalSongDistributionServiceUrl struct {
	bun.BaseModel `bun:"table:original_song_distribution_service_urls,alias:osdsu"`

	ID             string `bun:",pk"`
	OriginalSongID string `bun:"original_song_id,nullzero,notnull"`
	Service        string `bun:"service,nullzero,notnull"`
	URL            string `bun:"url,nullzero,notnull"`
}

type PDSUcsv struct {
	ProductID       string `csv:"product_id"`
	Name            string `csv:"name"`
	SpotifyURL      string `csv:"spotify_url"`
	AppleMusicURL   string `csv:"apple_music_url"`
	YouTubeMusicURL string `csv:"youtube_music_url"`
	LineMusicURL    string `csv:"line_music_url"`
}

type OSDSUcsv struct {
	OriginalSongID  string `csv:"original_song_id"`
	Name            string `csv:"name"`
	SpotifyURL      string `csv:"spotify_url"`
	AppleMusicURL   string `csv:"apple_music_url"`
	YouTubeMusicURL string `csv:"youtube_music_url"`
	LineMusicURL    string `csv:"line_music_url"`
}

type ArtistTsv struct {
	Name string `csv:"name"`
}

type GenreTsv struct {
	Name string `csv:"name"`
}

type TagTsv struct {
	Name    string `csv:"name"`
	TagType string `csv:"type"`
}

func main() {
	ctx := context.Background()
	db := initDB()

	fn := func(in io.Reader) gocsv.CSVReader {
		r := csv.NewReader(bom.NewReader(in)) // BOMの回避
		r.Comma = '\t'                        // 区切り文字をタブに変更
		r.Comment = '#'                       // #で始まる行はコメントと見なしスキップ
		return r
	}
	gocsv.SetCSVReader(fn)

	importProducts(ctx, db)
	importOriginalSongs(ctx, db)
	importPDSU(ctx, db)
	importOSDSU(ctx, db)
	importArtists(ctx, db)
	importGenres(ctx, db)
	importTags(ctx, db)
}

func initDB() *bun.DB {
	config, err := pgx.ParseConfig(os.Getenv("CONNECT_URL"))
	if err != nil {
		panic(err)
	}

	sqldb := stdlib.OpenDB(*config)
	db := bun.NewDB(sqldb, pgdialect.New())

	db.AddQueryHook(bundebug.NewQueryHook(
		// disable the hook
		bundebug.WithEnabled(false),

		// BUNDEBUG=1 logs failed queries
		// BUNDEBUG=2 logs all queries
		bundebug.FromEnv("BUNDEBUG"),
	))

	var v string
	if err = db.NewSelect().ColumnExpr("version()").Scan(context.Background(), &v); err != nil {
		log.Fatal(err)
	}
	log.Println(v)

	return db
}

func importProducts(ctx context.Context, db *bun.DB) {
	log.Println("start products import.")

	f, err := os.Open("./db/fixtures/products.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []Product
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	_, err = db.NewInsert().Model(&lines).
		On("CONFLICT (id) DO UPDATE").
		Set("name = EXCLUDED.name").
		Set("short_name = EXCLUDED.short_name").
		Set("product_type = EXCLUDED.product_type").
		Set("series_number = EXCLUDED.series_number").
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish products import.")
}

func importOriginalSongs(ctx context.Context, db *bun.DB) {
	log.Println("start original_songs import.")

	f, err := os.Open("./db/fixtures/original_songs.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []OriginalSong
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	_, err = db.NewInsert().Model(&lines).
		On("CONFLICT (id) DO UPDATE").
		Set("product_id = EXCLUDED.product_id").
		Set("name = EXCLUDED.name").
		Set("composer = EXCLUDED.composer").
		Set("arranger = EXCLUDED.arranger").
		Set("track_number = EXCLUDED.track_number").
		Set("is_original = EXCLUDED.is_original").
		Set("source_id = EXCLUDED.source_id").
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish original_songs import.")
}

func importPDSU(ctx context.Context, db *bun.DB) {
	log.Println("start product_distribution_service_urls import.")

	f, err := os.Open("./db/fixtures/product_distribution_service_urls.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []PDSUcsv
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var pdsus []ProductDistributionServiceUrl
	for _, l := range lines {
		am := ProductDistributionServiceUrl{
			ID:        cuid.New(),
			ProductID: l.ProductID,
			Service:   "apple_music",
			URL:       l.AppleMusicURL,
		}
		lm := ProductDistributionServiceUrl{
			ID:        cuid.New(),
			ProductID: l.ProductID,
			Service:   "line_music",
			URL:       l.LineMusicURL,
		}
		s := ProductDistributionServiceUrl{
			ID:        cuid.New(),
			ProductID: l.ProductID,
			Service:   "spotify",
			URL:       l.SpotifyURL,
		}
		ym := ProductDistributionServiceUrl{
			ID:        cuid.New(),
			ProductID: l.ProductID,
			Service:   "youtube_music",
			URL:       l.YouTubeMusicURL,
		}
		pdsus = append(pdsus, am)
		pdsus = append(pdsus, lm)
		pdsus = append(pdsus, s)
		pdsus = append(pdsus, ym)
	}

	_, err = db.NewInsert().Model(&pdsus).
		On("CONFLICT (product_id, service) DO UPDATE").
		Set("url = EXCLUDED.url").
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish product_distribution_service_urls import.")
}

func importOSDSU(ctx context.Context, db *bun.DB) {
	log.Println("start original_song_distribution_service_urls import.")

	f, err := os.Open("./db/fixtures/original_song_distribution_service_urls.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []OSDSUcsv
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var osdsus []OriginalSongDistributionServiceUrl
	for _, l := range lines {
		am := OriginalSongDistributionServiceUrl{
			ID:             cuid.New(),
			OriginalSongID: l.OriginalSongID,
			Service:        "apple_music",
			URL:            l.AppleMusicURL,
		}
		lm := OriginalSongDistributionServiceUrl{
			ID:             cuid.New(),
			OriginalSongID: l.OriginalSongID,
			Service:        "line_music",
			URL:            l.LineMusicURL,
		}
		s := OriginalSongDistributionServiceUrl{
			ID:             cuid.New(),
			OriginalSongID: l.OriginalSongID,
			Service:        "spotify",
			URL:            l.SpotifyURL,
		}
		ym := OriginalSongDistributionServiceUrl{
			ID:             cuid.New(),
			OriginalSongID: l.OriginalSongID,
			Service:        "youtube_music",
			URL:            l.YouTubeMusicURL,
		}
		osdsus = append(osdsus, am)
		osdsus = append(osdsus, lm)
		osdsus = append(osdsus, s)
		osdsus = append(osdsus, ym)
	}

	_, err = db.NewInsert().Model(&osdsus).
		On("CONFLICT (original_song_id, service) DO UPDATE").
		Set("url = EXCLUDED.url").
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish original_song_distribution_service_urls import.")
}

func importArtists(ctx context.Context, db *bun.DB) {
	log.Println("start artists import.")

	f, err := os.Open("./db/fixtures/artists.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []ArtistTsv
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var artists []schema.Artist
	for _, line := range lines {
		artist := schema.Artist{
			Name: line.Name,
		}
		artists = append(artists, artist)
	}

	_, err = db.NewInsert().Model(&artists).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish artists import.")
}

func importGenres(ctx context.Context, db *bun.DB) {
	log.Println("start genres import.")

	f, err := os.Open("./db/fixtures/genres.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []GenreTsv
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var genres []schema.Genre
	for _, line := range lines {
		genre := schema.Genre{
			Name: line.Name,
		}
		genres = append(genres, genre)
	}

	_, err = db.NewInsert().Model(&genres).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish genres import.")
}

func importTags(ctx context.Context, db *bun.DB) {
	log.Println("start tags import.")

	f, err := os.Open("./db/fixtures/tags.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []TagTsv
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var tags []schema.Tag
	for _, line := range lines {
		tag := schema.Tag{
			Name:    line.Name,
			TagType: line.TagType,
		}
		tags = append(tags, tag)
	}

	_, err = db.NewInsert().Model(&tags).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish tags import.")
}
