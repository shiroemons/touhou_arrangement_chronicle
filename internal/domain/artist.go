package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistRepository interface {
	Create(ctx context.Context, artist *entity.Artist) (*entity.Artist, error)
	Update(ctx context.Context, artist *entity.Artist) (*entity.Artist, error)
	Delete(ctx context.Context, artist *entity.Artist) error
	FindByID(ctx context.Context, id string) (*entity.Artist, error)
}
