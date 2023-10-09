package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongArrangeCircleRepository interface {
	Add(ctx context.Context, circle *schema.SongArrangeCircle) (*schema.SongArrangeCircle, error)
	Remove(ctx context.Context, circle *schema.SongArrangeCircle) error
}
