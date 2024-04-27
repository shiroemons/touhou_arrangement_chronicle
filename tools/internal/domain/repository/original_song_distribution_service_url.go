package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type OriginalSongDistributionServiceURLRepository interface {
	Add(ctx context.Context, serviceURL *schema.OriginalSongDistributionServiceURL) (*schema.OriginalSongDistributionServiceURL, error)
	Remove(ctx context.Context, serviceURL *schema.OriginalSongDistributionServiceURL) error
}
