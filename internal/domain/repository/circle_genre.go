package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleGenreRepository interface {
	Add(ctx context.Context, genre *entity.CircleGenre) (*entity.CircleGenre, error)
	Remove(ctx context.Context, genre *entity.CircleGenre) error
}
