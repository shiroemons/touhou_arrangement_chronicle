package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type SongArrangerRepository interface {
	Add(ctx context.Context, artist *schema.SongArranger) (*schema.SongArranger, error)
	Remove(ctx context.Context, artist *schema.SongArranger) error
}
