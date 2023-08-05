package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumRepository interface {
	Create(ctx context.Context, album *entity.Album) (*entity.Album, error)
	Update(ctx context.Context, album *entity.Album) (*entity.Album, error)
	Delete(ctx context.Context, album *entity.Album) error
	FindByIDs(ctx context.Context, ids []string) (entity.Albums, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Album, error)
}

type AlbumService interface {
	GetAlbumsByIDs(ctx context.Context, ids []string) (entity.Albums, error)
}
