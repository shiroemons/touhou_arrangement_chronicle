package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type OriginalSongRepository interface {
	All(ctx context.Context) ([]*entity.OriginalSong, error)
	FindByID(ctx context.Context, id string) (*entity.OriginalSong, error)
}
