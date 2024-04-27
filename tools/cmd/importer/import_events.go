package main

import (
	"log"
	"os"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/gocarina/gocsv"
	"github.com/jackc/pgtype"
	"github.com/lucsky/cuid"
	"github.com/samber/lo"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type EventCSV struct {
	EventName       string   `csv:"event_name" validate:"required"`
	EventSeriesName string   `csv:"event_series_name" validate:"required"`
	Status          string   `csv:"status" validate:"required"`
	StartDate       DateTime `csv:"start_date" validate:"required"`
	EndDate         DateTime `csv:"end_date" validate:"required"`
	Mode            string   `csv:"mode" validate:"required"`
	AddressRegion   string   `csv:"address_region" validate:"required"`
}

func (imp *Importer) importEvents() {
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

	// データの検証
	validate := validator.New()
	for i, line := range lines {
		if err := validate.Struct(line); err != nil {
			log.Printf("Invalid data at line %d: %v", i+1, err)
			continue
		}
	}

	imp.insertEventSeries(lines)

	imp.insertEvents(lines)

	log.Println("finish events import.")
}

func (imp *Importer) insertEventSeries(lines []EventCSV) {
	var eventSeries []schema.EventSeries
	for _, line := range lines {
		eSeries := new(schema.EventSeries)
		err := imp.db.NewSelect().Model(eSeries).
			Where("name = ?", line.EventSeriesName).
			Limit(1).
			Scan(imp.ctx)
		if err == nil {
			continue
		}

		es := schema.EventSeries{
			ID:          cuid.New(),
			Name:        line.EventSeriesName,
			DisplayName: line.EventSeriesName,
		}
		eventSeries = append(eventSeries, es)
	}

	if len(eventSeries) == 0 {
		return
	}

	_, err := imp.db.NewInsert().Model(&eventSeries).
		Ignore().
		Exec(imp.ctx)
	if err != nil {
		log.Fatal(err)
	}
}

func (imp *Importer) insertEvents(lines []EventCSV) {
	var events []schema.Event
	for _, line := range lines {
		eSeries := new(schema.EventSeries)
		err := imp.db.NewSelect().Model(eSeries).
			Where("name = ?", line.EventSeriesName).
			Limit(1).
			Scan(imp.ctx)
		if err != nil {
			log.Println(line.EventName, err)
			continue
		}

		e := schema.Event{
			ID:            cuid.New(),
			EventSeriesID: eSeries.ID,
			Name:          line.EventName,
			EventDates: pgtype.Daterange{
				Lower: pgtype.Date{
					Time:   line.StartDate.Time,
					Status: pgtype.Present,
				},
				Upper: pgtype.Date{
					Time:   line.EndDate.Time.AddDate(0, 0, 1),
					Status: pgtype.Present,
				},
				LowerType: pgtype.Inclusive,
				UpperType: pgtype.Exclusive,
				Status:    pgtype.Present,
			},
			DisplayName: line.EventName,
			EventStatus: line.Status,
			Format:      line.Mode,
			RegionCode:  line.AddressRegion,
			PublishedAt: lo.ToPtr(time.Now()),
		}
		events = append(events, e)
	}

	if len(events) == 0 {
		return
	}

	_, err := imp.db.NewInsert().Model(&events).
		Ignore().
		Exec(imp.ctx)
	if err != nil {
		log.Fatal(err)
	}
}
