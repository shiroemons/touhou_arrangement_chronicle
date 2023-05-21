package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongGenreRepository interface {
	Add(ctx context.Context, genre *entity.SongGenre) (*entity.SongGenre, error)
	Remove(ctx context.Context, genre *entity.SongGenre) error
}
