package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type AlbumDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *schema.AlbumDistributionServiceURL) (*schema.AlbumDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *schema.AlbumDistributionServiceURL) error
}
