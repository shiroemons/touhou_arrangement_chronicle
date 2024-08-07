package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type OriginalSongRepository interface {
	All(ctx context.Context) ([]*schema.OriginalSong, error)
	FindByIDs(ctx context.Context, ids []string) ([]*schema.OriginalSong, error)
}
