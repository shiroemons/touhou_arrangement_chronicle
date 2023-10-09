package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type ArtistRepository interface {
	Create(ctx context.Context, artist *schema.Artist) (*schema.Artist, error)
	Update(ctx context.Context, artist *schema.Artist) (*schema.Artist, error)
	Delete(ctx context.Context, artist *schema.Artist) error
	FindByIDs(ctx context.Context, ids []string) (schema.Artists, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*schema.Artist, error)
}
