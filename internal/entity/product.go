package entity

import (
	"time"

	"github.com/uptrace/bun"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Product struct {
	bun.BaseModel `bun:"table:products,alias:p"`

	ID                             string                           `bun:",pk"`
	Name                           string                           `bun:"name,nullzero,notnull"`
	ShortName                      string                           `bun:"short_name,nullzero,notnull"`
	ProductType                    string                           `bun:"product_type,nullzero,notnull"`
	SeriesNumber                   float64                          `bun:"series_number,nullzero,notnull"`
	ProductDistributionServiceURLs []*ProductDistributionServiceURL `bun:"rel:has-many,join:id=product_id"`
	CreatedAt                      time.Time                        `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                      time.Time                        `bun:"updated_at,notnull,default:current_timestamp"`
}

// Products Method Injection
type Products []*Product

// ToGraphQL Convert to GraphQL Schema
func (e *Product) ToGraphQL() *model.Product {
	productType, err := model.ToProductType(e.ProductType)
	if err != nil {
		zap.S().Warnf("ToProductType error: %s", err)
	}

	return &model.Product{
		ID:           e.ID,
		Name:         e.Name,
		ShortName:    e.ShortName,
		ProductType:  productType,
		SeriesNumber: e.SeriesNumber,
	}
}

func (arr Products) ToGraphQLs() []*model.Product {
	res := make([]*model.Product, len(arr))
	for i, p := range arr {
		res[i] = p.ToGraphQL()
	}
	return res
}
