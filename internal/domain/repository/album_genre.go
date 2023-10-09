package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumGenreRepository interface {
	Add(ctx context.Context, genre *entity.AlbumGenre) (*entity.AlbumGenre, error)
	Remove(ctx context.Context, genre *entity.AlbumGenre) error
}
