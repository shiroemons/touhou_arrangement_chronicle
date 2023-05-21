package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *entity.AlbumDistributionServiceURL) (*entity.AlbumDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *entity.AlbumDistributionServiceURL) error
}
