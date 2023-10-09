package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongLyricistRepository interface {
	Add(ctx context.Context, artist *schema.SongLyricist) (*schema.SongLyricist, error)
	Remove(ctx context.Context, artist *schema.SongLyricist) error
}
