package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/shopspring/decimal"
	"github.com/uptrace/bun"
)

type AlbumConsignmentShop struct {
	bun.BaseModel `bun:"table:album_consignment_shops,alias:alcs"`

	ID          string              `bun:",pk"`
	AlbumID     string              `bun:"album_id,nullzero,notnull"`
	Shop        string              `bun:"shop,nullzero,notnull"`
	URL         string              `bun:"url,nullzero,notnull"`
	TaxIncluded bool                `bun:"tax_included,nullzero,notnull,default:false"`
	ShopPrice   decimal.NullDecimal `bun:"shop_price"`
	Currency    string              `bun:"currency,nullzero,notnull,default:'JPY'"`
	CreatedAt   time.Time           `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time           `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*AlbumConsignmentShop)(nil)

func (e *AlbumConsignmentShop) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
