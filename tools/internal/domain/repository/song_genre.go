package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type SongGenreRepository interface {
	Add(ctx context.Context, genre *schema.SongGenre) (*schema.SongGenre, error)
	Remove(ctx context.Context, genre *schema.SongGenre) error
}
