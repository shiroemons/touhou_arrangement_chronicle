package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type SongDistributionServiceURL struct {
	bun.BaseModel `bun:"table:song_distribution_service_urls,alias:sdsu"`

	ID        string    `bun:",pk"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	Service   string    `bun:"service,nullzero,notnull"`
	URL       string    `bun:"url,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*SongDistributionServiceURL)(nil)

func (e *SongDistributionServiceURL) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
