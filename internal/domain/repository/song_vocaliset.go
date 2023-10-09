package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongVocalistRepository interface {
	Add(ctx context.Context, artist *entity.SongVocalist) (*entity.SongVocalist, error)
	Remove(ctx context.Context, artist *entity.SongVocalist) error
}
