package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *entity.SongDistributionServiceURL) (*entity.SongDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *entity.SongDistributionServiceURL) error
}
