package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongArrangeCircleRepository interface {
	Add(ctx context.Context, circle *entity.SongArrangeCircle) (*entity.SongArrangeCircle, error)
	Remove(ctx context.Context, circle *entity.SongArrangeCircle) error
}
