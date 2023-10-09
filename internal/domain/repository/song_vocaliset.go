package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongVocalistRepository interface {
	Add(ctx context.Context, artist *schema.SongVocalist) (*schema.SongVocalist, error)
	Remove(ctx context.Context, artist *schema.SongVocalist) error
}
