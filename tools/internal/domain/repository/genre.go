package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type GenreRepository interface {
	Create(ctx context.Context, genre *schema.Genre) (*schema.Genre, error)
	Update(ctx context.Context, genre *schema.Genre) (*schema.Genre, error)
	Delete(ctx context.Context, genre *schema.Genre) error
	FindAll(ctx context.Context) ([]*schema.Genre, error)
}
