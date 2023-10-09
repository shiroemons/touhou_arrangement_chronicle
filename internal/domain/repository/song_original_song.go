package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongOriginalSongRepository interface {
	Add(ctx context.Context, originalSong *entity.SongOriginalSong) (*entity.SongOriginalSong, error)
	Remove(ctx context.Context, originalSong *entity.SongOriginalSong) error
}
