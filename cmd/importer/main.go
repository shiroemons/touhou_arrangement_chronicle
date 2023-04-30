package main

import (
	"context"
	"encoding/csv"
	"io"
	"os"
	"time"

	"github.com/gocarina/gocsv"
	"github.com/spkg/bom"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/infra/store"
)

type Importer struct {
	ctx context.Context
	db  *bun.DB
}

func main() {
	run()
}

func initDB() *bun.DB {
	return store.NewDB(os.Getenv("CONNECT_URL"))
}

func run() {
	ctx := context.Background()
	db := initDB()

	fn := func(in io.Reader) gocsv.CSVReader {
		r := csv.NewReader(bom.NewReader(in)) // BOMの回避
		r.Comma = '\t'                        // 区切り文字をタブに変更
		r.Comment = '#'                       // #で始まる行はコメントと見なしスキップ
		r.LazyQuotes = true
		r.FieldsPerRecord = -1
		return r
	}
	gocsv.SetCSVReader(fn)

	imp := &Importer{
		ctx: ctx,
		db:  db,
	}

	imp.importEvents()
	imp.importCircles()
	imp.importArtists()
	imp.importAlbums()
	imp.importAlbumServiceUrl()
}

type DateTime struct {
	time.Time
}

const layout = "2006-01-02"

func (date *DateTime) MarshalCSV() (string, error) {
	return date.Time.Format(layout), nil
}

func (date *DateTime) String() string {
	return date.Format(layout) // Redundant, just for example
}

func (date *DateTime) UnmarshalCSV(csv string) (err error) {
	date.Time, err = time.Parse(layout, csv)
	return err
}
