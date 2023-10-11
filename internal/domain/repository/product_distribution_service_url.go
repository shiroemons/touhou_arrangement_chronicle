package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type ProductDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *schema.ProductDistributionServiceURL) (*schema.ProductDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *schema.ProductDistributionServiceURL) error
}
