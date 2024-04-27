package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type AlbumGenreRepository interface {
	Add(ctx context.Context, genre *schema.AlbumGenre) (*schema.AlbumGenre, error)
	Remove(ctx context.Context, genre *schema.AlbumGenre) error
}
