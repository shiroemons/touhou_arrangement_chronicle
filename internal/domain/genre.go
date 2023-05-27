package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type GenreRepository interface {
	Create(ctx context.Context, genre *entity.Genre) (*entity.Genre, error)
	Update(ctx context.Context, genre *entity.Genre) (*entity.Genre, error)
	Delete(ctx context.Context, genre *entity.Genre) error
	FindAll(ctx context.Context) ([]*entity.Genre, error)
}

type GenreService interface {
	All(ctx context.Context) (entity.Genres, error)
}
