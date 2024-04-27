package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type CircleGenreRepository interface {
	Add(ctx context.Context, genre *schema.CircleGenre) (*schema.CircleGenre, error)
	Remove(ctx context.Context, genre *schema.CircleGenre) error
}
