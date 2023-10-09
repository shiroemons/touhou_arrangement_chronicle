package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type OriginalSongDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *entity.OriginalSongDistributionServiceURL) (*entity.OriginalSongDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *entity.OriginalSongDistributionServiceURL) error
}
