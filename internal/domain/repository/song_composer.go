package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongComposerRepository interface {
	Add(ctx context.Context, artist *entity.SongComposer) (*entity.SongComposer, error)
	Remove(ctx context.Context, artist *entity.SongComposer) error
}
