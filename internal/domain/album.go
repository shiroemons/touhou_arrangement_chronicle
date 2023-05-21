package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumRepository interface {
	Create(ctx context.Context, album *entity.Album) (*entity.Album, error)
	Update(ctx context.Context, album *entity.Album) (*entity.Album, error)
	Delete(ctx context.Context, album *entity.Album) error
	FindByID(ctx context.Context, id string) (*entity.Album, error)
}
