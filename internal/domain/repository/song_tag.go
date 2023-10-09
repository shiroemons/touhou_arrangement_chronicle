package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongTagRepository interface {
	Add(ctx context.Context, tag *entity.SongTag) (*entity.SongTag, error)
	Remove(ctx context.Context, tag *entity.SongTag) error
}
