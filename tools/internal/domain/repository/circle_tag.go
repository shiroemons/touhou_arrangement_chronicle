package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type CircleTagRepository interface {
	Add(ctx context.Context, tag *schema.CircleTag) (*schema.CircleTag, error)
	Remove(ctx context.Context, tag *schema.CircleTag) error
}
