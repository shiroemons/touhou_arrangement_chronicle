package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongArrangerRepository interface {
	Add(ctx context.Context, artist *entity.SongArranger) (*entity.SongArranger, error)
	Remove(ctx context.Context, artist *entity.SongArranger) error
}
