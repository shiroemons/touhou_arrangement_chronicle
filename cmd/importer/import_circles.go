package main

import (
	"database/sql"
	"errors"
	"log"
	"os"

	"github.com/gocarina/gocsv"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type CircleCSV struct {
	CircleName string `csv:"circle_name"`
	URL        string `csv:"url"`
	BlogURL    string `csv:"blog_url"`
}

func (imp *Importer) importCircles() {
	log.Println("start circles import.")

	f, err := os.Open("./tmp/circles.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []CircleCSV
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var circles []schema.Circle
	for _, line := range lines {
		circle := schema.Circle{}
		err = imp.db.NewSelect().Model(&circle).Where("name = ?", line.CircleName).Limit(1).Scan(imp.ctx)
		if err != nil && errors.Is(err, sql.ErrNoRows) {
			c := schema.Circle{
				Name: line.CircleName,
			}
			if line.URL != "" {
				c.URL = line.URL
			}
			if line.BlogURL != "" {
				c.BlogURL = line.BlogURL
			}
			circles = append(circles, c)
		}
	}

	if len(circles) == 0 {
		return
	}

	_, err = imp.db.NewInsert().Model(&circles).
		Ignore().
		Exec(imp.ctx)
	if err != nil {
		log.Fatal(err)
	}

	log.Println("finish circles import.")
}
