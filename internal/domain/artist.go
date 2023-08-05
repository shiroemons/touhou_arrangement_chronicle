package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistRepository interface {
	Create(ctx context.Context, artist *entity.Artist) (*entity.Artist, error)
	Update(ctx context.Context, artist *entity.Artist) (*entity.Artist, error)
	Delete(ctx context.Context, artist *entity.Artist) error
	FindByIDs(ctx context.Context, ids []string) (entity.Artists, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*entity.Artist, error)
}

type ArtistService interface {
	GetArtistsByIDs(ctx context.Context, ids []string) (entity.Artists, error)
	GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Artists, error)
}
