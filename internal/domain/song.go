package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongRepository interface {
	Create(ctx context.Context, song *entity.Song) (*entity.Song, error)
	Update(ctx context.Context, song *entity.Song) (*entity.Song, error)
	Delete(ctx context.Context, song *entity.Song) error
	FindByIDs(ctx context.Context, ids []string) (entity.Songs, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Song, error)
}

type SongService interface {
	GetSongsByIDs(ctx context.Context, ids []string) (entity.Songs, error)
}
