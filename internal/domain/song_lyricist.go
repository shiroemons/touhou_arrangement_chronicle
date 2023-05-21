package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongLyricistRepository interface {
	Add(ctx context.Context, artist *entity.SongLyricist) (*entity.SongLyricist, error)
	Remove(ctx context.Context, artist *entity.SongLyricist) error
}
