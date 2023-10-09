package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongISRCRepository interface {
	Add(ctx context.Context, isrc *entity.SongISRC) (*entity.SongISRC, error)
	Remove(ctx context.Context, isrc *entity.SongISRC) error
}
