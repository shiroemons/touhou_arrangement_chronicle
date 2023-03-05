package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type AlbumUPC struct {
	bun.BaseModel `bun:"table:album_upcs,alias:alu"`

	ID        string    `bun:",pk"`
	AlbumID   string    `bun:"album_id,nullzero,notnull"`
	UPC       string    `bun:"upc,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*AlbumUPC)(nil)

func (e *AlbumUPC) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
