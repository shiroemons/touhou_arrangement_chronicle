package schema

import (
	"time"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shopspring/decimal"
	"github.com/uptrace/bun"
	"go.uber.org/zap"
)

type AlbumConsignmentShop struct {
	bun.BaseModel `bun:"table:album_consignment_shops,alias:alcs"`

	ID          string              `bun:",pk,default:cuid()"`
	AlbumID     string              `bun:"album_id,nullzero,notnull"`
	Shop        string              `bun:"shop,nullzero,notnull"`
	URL         string              `bun:"url,nullzero,notnull"`
	TaxIncluded bool                `bun:"tax_included,nullzero,notnull,default:false"`
	ShopPrice   decimal.NullDecimal `bun:"shop_price"`
	Currency    string              `bun:"currency,nullzero,notnull,default:'JPY'"`
	CreatedAt   time.Time           `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time           `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *AlbumConsignmentShop) ToGraphQL() *model.ConsignmentShop {
	shop, err := model.ToShop(e.Shop)
	if err != nil {
		zap.S().Warnf("ToShop error: %s", err)
		return nil
	}
	var shopPriceString string
	if e.ShopPrice.Valid {
		// e.ShopPriceを文字列化する
		shopPriceString = e.ShopPrice.Decimal.String()
	}

	return &model.ConsignmentShop{
		ID:          e.ID,
		Shop:        shop,
		URL:         e.URL,
		TaxIncluded: e.TaxIncluded,
		ShopPrice:   shopPriceString,
		Currency:    e.Currency,
	}
}
