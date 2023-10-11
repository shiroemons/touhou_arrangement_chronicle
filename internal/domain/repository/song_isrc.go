package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongISRCRepository interface {
	Add(ctx context.Context, isrc *schema.SongISRC) (*schema.SongISRC, error)
	Remove(ctx context.Context, isrc *schema.SongISRC) error
}
