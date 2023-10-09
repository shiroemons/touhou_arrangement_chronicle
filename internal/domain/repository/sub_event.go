package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SubEventRepository interface {
	Create(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error)
	Update(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error)
	Delete(ctx context.Context, subEvent *entity.SubEvent) error
	FindByIDs(ctx context.Context, ids []string) (entity.SubEvents, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.SubEvent, error)
}
