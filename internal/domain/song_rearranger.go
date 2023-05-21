package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongRearrangerRepository interface {
	Add(ctx context.Context, artist *entity.SongRearranger) (*entity.SongRearranger, error)
	Remove(ctx context.Context, artist *entity.SongRearranger) error
}
