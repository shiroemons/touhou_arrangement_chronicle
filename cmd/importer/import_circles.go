package main

import (
	"context"
	"log"
	"os"

	"github.com/gocarina/gocsv"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
	"github.com/uptrace/bun"
)

type CircleCSV struct {
	CircleName string `csv:"circle_name"`
}

func importCircles(ctx context.Context, db *bun.DB) {
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
		c := entity.Circle{
			Name: line.CircleName,
		}
		circles = append(circles, c)
	}

	_, err = db.NewInsert().Model(&circles).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish circles import.")
}
