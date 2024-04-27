package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type AlbumRepository interface {
	Create(ctx context.Context, album *schema.Album) (*schema.Album, error)
	Update(ctx context.Context, album *schema.Album) (*schema.Album, error)
	Delete(ctx context.Context, album *schema.Album) error
	FindByIDs(ctx context.Context, ids []string) ([]*schema.Album, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Album, error)
}
