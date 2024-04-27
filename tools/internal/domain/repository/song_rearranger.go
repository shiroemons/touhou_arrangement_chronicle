package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type SongRearrangerRepository interface {
	Add(ctx context.Context, artist *schema.SongRearranger) (*schema.SongRearranger, error)
	Remove(ctx context.Context, artist *schema.SongRearranger) error
}
