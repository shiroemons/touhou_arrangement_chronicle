package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type TagRepository interface {
	Create(ctx context.Context, tag *schema.Tag) (*schema.Tag, error)
	Update(ctx context.Context, tag *schema.Tag) (*schema.Tag, error)
	Delete(ctx context.Context, tag *schema.Tag) error
	FindAll(ctx context.Context) ([]*schema.Tag, error)
}
