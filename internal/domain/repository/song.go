package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongRepository interface {
	Create(ctx context.Context, song *schema.Song) (*schema.Song, error)
	Update(ctx context.Context, song *schema.Song) (*schema.Song, error)
	Delete(ctx context.Context, song *schema.Song) error
	FindByIDs(ctx context.Context, ids []string) (schema.Songs, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Song, error)
}
