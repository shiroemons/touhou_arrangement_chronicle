package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SubEventRepository interface {
	Create(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error)
	Update(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error)
	Delete(ctx context.Context, subEvent *entity.SubEvent) error
	FindByID(ctx context.Context, id string) (*entity.SubEvent, error)
}
