package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *schema.SongDistributionServiceURL) (*schema.SongDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *schema.SongDistributionServiceURL) error
}
