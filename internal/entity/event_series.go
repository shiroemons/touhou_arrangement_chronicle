package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type EventSeries struct {
	bun.BaseModel `bun:"table:event_series,alias:es"`

	ID          string    `bun:",pk,default:xid()"`
	Name        string    `bun:"name,nullzero,notnull,unique"`
	DisplayName string    `bun:"display_name,nullzero,notnull"`
	Events      []*Event  `bun:"rel:has-many,join:id=event_series_id"`
	CreatedAt   time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
