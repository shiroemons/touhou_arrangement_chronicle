package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleRepository interface {
	Create(ctx context.Context, circle *entity.Circle) (*entity.Circle, error)
	Update(ctx context.Context, circle *entity.Circle) (*entity.Circle, error)
	Delete(ctx context.Context, circle *entity.Circle) error
	FindByIDs(ctx context.Context, ids []string) (entity.Circles, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*entity.Circle, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Circle, error)
}
