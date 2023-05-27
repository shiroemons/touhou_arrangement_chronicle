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
	FindByID(ctx context.Context, id string) (*entity.Artist, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*entity.Artist, error)
}

type ArtistService interface {
	Get(ctx context.Context, id string) (*entity.Artist, error)
	GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Artists, error)
}
