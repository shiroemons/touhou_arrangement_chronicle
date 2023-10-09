package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongOriginalSongRepository interface {
	Add(ctx context.Context, originalSong *schema.SongOriginalSong) (*schema.SongOriginalSong, error)
	Remove(ctx context.Context, originalSong *schema.SongOriginalSong) error
}
