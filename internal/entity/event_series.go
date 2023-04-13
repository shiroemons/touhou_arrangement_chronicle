package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type EventSeries struct {
	bun.BaseModel `bun:"table:event_series,alias:es"`

	ID          string    `bun:",pk"`
	Name        string    `bun:"name,nullzero,notnull,unique"`
	DisplayName string    `bun:"display_name,nullzero,notnull"`
	Events      []*Event  `bun:"rel:has-many,join:id=event_series_id"`
	CreatedAt   time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*EventSeries)(nil)

func (e *EventSeries) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
