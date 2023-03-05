package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type TrackISRC struct {
	bun.BaseModel `bun:"table:track_isrcs,alias:ti"`

	ID        string    `bun:",pk"`
	TrackID   string    `bun:"track_id,nullzero,notnull"`
	ISRC      string    `bun:"isrc,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*TrackISRC)(nil)

func (e *TrackISRC) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
