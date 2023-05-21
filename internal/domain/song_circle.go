package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongCircleRepository interface {
	Add(ctx context.Context, circle *entity.SongCircle) (*entity.SongCircle, error)
	Remove(ctx context.Context, circle *entity.SongCircle) error
}
