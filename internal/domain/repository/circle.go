package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type CircleRepository interface {
	Create(ctx context.Context, circle *schema.Circle) (*schema.Circle, error)
	Update(ctx context.Context, circle *schema.Circle) (*schema.Circle, error)
	Delete(ctx context.Context, circle *schema.Circle) error
	FindByIDs(ctx context.Context, ids []string) (schema.Circles, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*schema.Circle, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Circle, error)
}
