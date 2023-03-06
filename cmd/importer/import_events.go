package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/gocarina/gocsv"
	"github.com/rs/xid"
	"github.com/uptrace/bun"
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

type EventSeries struct {
	bun.BaseModel `bun:"table:event_series,alias:es"`

	ID          string    `bun:",pk"`
	Name        string    `bun:"name,nullzero,notnull,unique"`
	DisplayName string    `bun:"display_name,nullzero,notnull"`
	CreatedAt   time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

type Event struct {
	bun.BaseModel `bun:"table:events,alias:e"`

	ID            string      `bun:",pk"`
	EventSeriesID string      `bun:"event_series_id,nullzero,notnull"`
	Name          string      `bun:"name,nullzero,notnull,unique"`
	DisplayName   string      `bun:"display_name,nullzero,notnull"`
	EventDates    []time.Time `bun:"event_dates,nullzero"`
	EventStatus   string      `bun:"event_status,nullzero,notnull,default:'scheduled'::event_status"`
	Format        string      `bun:"format,nullzero,notnull,default:'offline'::event_format"`
	RegionCode    string      `bun:"region_code,nullzero,notnull,default:'JP'"`
	Address       string      `bun:"address,nullzero,notnull,default:''"`
	Description   string      `bun:"description,nullzero,notnull,default:''"`
	URL           string      `bun:"url,nullzero,notnull,default:''"`
	TwitterURL    string      `bun:"twitter_url,nullzero,notnull,default:''"`
	CreatedAt     time.Time   `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt     time.Time   `bun:"updated_at,notnull,default:current_timestamp"`
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

	var eventSeries []EventSeries
	for _, line := range lines {
		es := EventSeries{
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

	var events []Event
	for _, line := range lines {
		eSeries := new(EventSeries)
		err = db.NewSelect().Model(eSeries).Where("name = ?", line.EventSeriesName).Limit(1).Scan(ctx)
		if err != nil {
			log.Println(line.EventName, err)
			continue
		}

		e := Event{
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
