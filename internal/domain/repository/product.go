package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductRepository interface {
	All(ctx context.Context) ([]*entity.Product, error)
	FindByIDs(ctx context.Context, ids []string) (entity.Products, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Product, error)
}
