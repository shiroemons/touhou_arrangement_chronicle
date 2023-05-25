package entity

import (
	"time"

	"github.com/uptrace/bun"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type ProductDistributionServiceURL struct {
	bun.BaseModel `bun:"table:product_distribution_service_urls,alias:pdsu"`

	ID        string    `bun:",pk,default:xid()"`
	ProductID string    `bun:"product_id,nullzero,notnull"`
	Service   string    `bun:"service,nullzero,notnull"`
	URL       string    `bun:"url,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *ProductDistributionServiceURL) ToGraphQL() *model.ProductDistributionServiceURL {
	service, err := model.ToDistributionService(e.Service)
	if err != nil {
		zap.S().Warnf("ToDistributionService error: %s", err)
	}

	return &model.ProductDistributionServiceURL{
		ID:      e.ID,
		Service: service,
		URL:     e.URL,
	}
}
