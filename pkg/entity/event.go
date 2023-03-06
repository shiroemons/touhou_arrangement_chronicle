package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type Event struct {
	bun.BaseModel `bun:"table:events,alias:e"`

	ID            string      `bun:",pk"`
	EventSeriesID string      `bun:"event_series_id,nullzero,notnull"`
	EventSeries   EventSeries `bun:"rel:belongs-to,join:event_series_id=id"`
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
	SubEvents     []*SubEvent `bun:"rel:has-many,join:id=sub_event_id"`
	CreatedAt     time.Time   `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt     time.Time   `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Event)(nil)

func (e *Event) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
