package schema

import (
	"time"

	"github.com/jackc/pgtype"
	"github.com/samber/lo"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Event struct {
	bun.BaseModel `bun:"table:events,alias:e"`

	ID            string           `bun:",pk,default:cuid()"`
	EventSeriesID string           `bun:"event_series_id,nullzero,notnull"`
	EventSeries   *EventSeries     `bun:"rel:belongs-to,join:event_series_id=id"`
	Name          string           `bun:"name,nullzero,notnull,unique"`
	DisplayName   string           `bun:"display_name,nullzero,notnull"`
	Slug          string           `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	EventDates    pgtype.Daterange `bun:"event_dates,type:daterange,nullzero"`
	EventStatus   string           `bun:"event_status,nullzero,notnull,default:'scheduled'::event_status"`
	Format        string           `bun:"format,nullzero,notnull,default:'offline'::event_format"`
	RegionCode    string           `bun:"region_code,nullzero,notnull,default:'JP'"`
	Address       string           `bun:"address,nullzero,notnull,default:''"`
	Description   string           `bun:"description,nullzero,notnull,default:''"`
	URL           string           `bun:"url,nullzero,notnull,default:''"`
	TwitterURL    string           `bun:"twitter_url,nullzero,notnull,default:''"`
	SubEvents     []*SubEvent      `bun:"rel:has-many,join:id=event_id"`
	CreatedAt     time.Time        `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt     time.Time        `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *Event) ToGraphQL() *model.Event {
	subEvents := ConvertSlice(e.SubEvents, func(v *SubEvent) *model.SubEvent { return v.ToGraphQL() })

	event := &model.Event{
		ID:          e.ID,
		Name:        e.Name,
		DisplayName: e.DisplayName,
		Slug:        e.Slug,
		RegionCode:  e.RegionCode,
		Address:     e.Address,
		Description: e.Description,
		URL:         e.URL,
		TwitterURL:  e.TwitterURL,
		SubEvents:   subEvents,
	}
	if e.EventSeriesID != "" {
		event.Series = &model.EventSeries{ID: e.EventSeriesID}
	}
	if e.EventDates.Status == pgtype.Present {
		event.StartDate = lo.ToPtr(e.EventDates.Lower.Time.Format("2006-01-02"))
		// event.EndDate は、e.EventDates.Upper.Timeを1日前の情報を格納する
		event.EndDate = lo.ToPtr(e.EventDates.Upper.Time.AddDate(0, 0, -1).Format("2006-01-02"))
	}
	if e.EventStatus != "" {
		event.Status = model.EventStatus(e.EventStatus)
	}
	if e.Format != "" {
		event.Format = model.EventFormat(e.Format)
	}
	return event
}

type Events []*Event

func (e Events) ToGraphQLs() []*model.Event {
	events := make([]*model.Event, len(e))
	for i, event := range e {
		events[i] = event.ToGraphQL()
	}
	return events
}