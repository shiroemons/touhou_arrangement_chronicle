package main

import (
	"database/sql"
	"errors"
	"log"
	"os"

	"github.com/gocarina/gocsv"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleCSV struct {
	CircleName string `csv:"circle_name"`
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

	var circles []entity.Circle
	for _, line := range lines {
		circle := entity.Circle{}
		err = imp.db.NewSelect().Model(&circle).Where("name = ?", line.CircleName).Limit(1).Scan(imp.ctx)
		if err != nil && errors.Is(err, sql.ErrNoRows) {
			c := entity.Circle{
				Name: line.CircleName,
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
