package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongCircleRepository interface {
	Add(ctx context.Context, circle *schema.SongCircle) (*schema.SongCircle, error)
	Remove(ctx context.Context, circle *schema.SongCircle) error
}
