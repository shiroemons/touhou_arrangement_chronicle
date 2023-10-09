package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type TagRepository interface {
	Create(ctx context.Context, tag *entity.Tag) (*entity.Tag, error)
	Update(ctx context.Context, tag *entity.Tag) (*entity.Tag, error)
	Delete(ctx context.Context, tag *entity.Tag) error
	FindAll(ctx context.Context) ([]*entity.Tag, error)
}
