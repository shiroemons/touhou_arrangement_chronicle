package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type OriginalSongDistributionServiceURL struct {
	bun.BaseModel `bun:"table:original_song_distribution_service_urls,alias:osdsu"`

	ID             string    `bun:",pk"`
	OriginalSongID string    `bun:"original_song_id,nullzero,notnull"`
	Service        string    `bun:"service,nullzero,notnull"`
	URL            string    `bun:"url,nullzero,notnull"`
	CreatedAt      time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*OriginalSongDistributionServiceURL)(nil)

func (e *OriginalSongDistributionServiceURL) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
