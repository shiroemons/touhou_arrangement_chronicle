package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongComposerRepository interface {
	Add(ctx context.Context, artist *schema.SongComposer) (*schema.SongComposer, error)
	Remove(ctx context.Context, artist *schema.SongComposer) error
}
