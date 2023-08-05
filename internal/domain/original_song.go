package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type OriginalSongRepository interface {
	All(ctx context.Context) ([]*entity.OriginalSong, error)
	FindByIDs(ctx context.Context, ids []string) (entity.OriginalSongs, error)
}

type OriginalSongService interface {
	GetAll(ctx context.Context) (entity.OriginalSongs, error)
	GetOriginalSongsByIDs(ctx context.Context, ids []string) (entity.OriginalSongs, error)
}
