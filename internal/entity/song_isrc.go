package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type SongISRC struct {
	bun.BaseModel `bun:"table:song_isrcs,alias:si"`

	ID        string    `bun:",pk"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	ISRC      string    `bun:"isrc,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*SongISRC)(nil)

func (e *SongISRC) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
