package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/shopspring/decimal"
	"github.com/uptrace/bun"
)

type Album struct {
	bun.BaseModel `bun:"table:albums,alias:al"`

	ID                           string                         `bun:",pk"`
	Name                         string                         `bun:"name,nullzero,notnull"`
	ReleaseCircleName            string                         `bun:"release_circle_name,nullzero,notnull,default:''"`
	ReleaseDate                  *time.Time                     `bun:"release_date"`
	EventID                      string                         `bun:"event_id,nullzero,notnull,default:''"`
	Event                        *Event                         `bun:"rel:belongs-to,join:event_id=id"`
	SubEventID                   string                         `bun:"sub_event_id,nullzero,notnull,default:''"`
	SubEvent                     *SubEvent                      `bun:"rel:belongs-to,join:sub_event_id=id"`
	SearchEnabled                bool                           `bun:"search_enabled,nullzero,notnull,default:true"`
	AlbumNumber                  string                         `bun:"album_number,nullzero,notnull,default:''"`
	EventPrice                   decimal.NullDecimal            `bun:"event_price"`
	Currency                     string                         `bun:"currency,nullzero,notnull,default:'JPY'"`
	Credit                       string                         `bun:"credit,nullzero,notnull,default:''"`
	Introduction                 string                         `bun:"introduction,nullzero,notnull,default:''"`
	URL                          string                         `bun:"url,nullzero,notnull,default:''"`
	AlbumConsignmentShops        []*AlbumConsignmentShop        `bun:"rel:has-many,join:id=album_id"`
	AlbumDistributionServiceURLs []*AlbumDistributionServiceURL `bun:"rel:has-many,join:id=album_id"`
	AlbumUPCs                    []*AlbumUPC                    `bun:"rel:has-many,join:id=album_id"`
	Songs                        []*Song                        `bun:"rel:has-many,join:id=album_id"`
	Circles                      []*Circle                      `bun:"m2m:albums_circles,join:Album=Circle"`
	GenreTags                    []*Tag                         `bun:"m2m:albums_genres,join:Album=GenreTag"`
	Tags                         []*Tag                         `bun:"m2m:albums_tags,join:Album=Tag"`
	CreatedAt                    time.Time                      `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                    time.Time                      `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Album)(nil)

func (e *Album) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
