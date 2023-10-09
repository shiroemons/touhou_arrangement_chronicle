package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongTagRepository interface {
	Add(ctx context.Context, tag *schema.SongTag) (*schema.SongTag, error)
	Remove(ctx context.Context, tag *schema.SongTag) error
}
