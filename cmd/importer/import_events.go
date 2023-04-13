package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/gocarina/gocsv"
	"github.com/rs/xid"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventCSV struct {
	EventName       string   `csv:"event_name"`
	EventSeriesName string   `csv:"event_series_name"`
	Status          string   `csv:"status"`
	StartDate       DateTime `csv:"start_date"`
	EndDate         DateTime `csv:"end_date"`
	Mode            string   `csv:"mode"`
	AddressRegion   string   `csv:"address_region"`
}

func importEvents(ctx context.Context, db *bun.DB) {
	log.Println("start events import.")

	f, err := os.Open("./tmp/events.tsv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	var lines []EventCSV
	if err = gocsv.UnmarshalFile(f, &lines); err != nil {
		log.Fatal(err)
	}

	var eventSeries []entity.EventSeries
	for _, line := range lines {
		es := entity.EventSeries{
			ID:          xid.New().String(),
			Name:        line.EventSeriesName,
			DisplayName: line.EventSeriesName,
		}
		eventSeries = append(eventSeries, es)
	}

	_, err = db.NewInsert().Model(&eventSeries).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	var events []entity.Event
	for _, line := range lines {
		eSeries := new(entity.EventSeries)
		err = db.NewSelect().Model(eSeries).Where("name = ?", line.EventSeriesName).Limit(1).Scan(ctx)
		if err != nil {
			log.Println(line.EventName, err)
			continue
		}

		e := entity.Event{
			ID:            xid.New().String(),
			EventSeriesID: eSeries.ID,
			Name:          line.EventName,
			EventDates:    []time.Time{line.StartDate.Time, line.EndDate.Time},
			DisplayName:   line.EventName,
			EventStatus:   line.Status,
			Format:        line.Mode,
			RegionCode:    line.AddressRegion,
		}
		events = append(events, e)
	}

	_, err = db.NewInsert().Model(&events).
		Ignore().
		Exec(ctx)
	if err != nil {
		panic(err)
	}

	log.Println("finish events import.")
}
