package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *entity.ProductDistributionServiceURL) (*entity.ProductDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *entity.ProductDistributionServiceURL) error
}
