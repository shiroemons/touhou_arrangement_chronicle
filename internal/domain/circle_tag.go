package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleTagRepository interface {
	Add(ctx context.Context, tag *entity.CircleTag) (*entity.CircleTag, error)
	Remove(ctx context.Context, tag *entity.CircleTag) error
}
