package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductRepository interface {
	All(ctx context.Context) ([]*entity.Product, error)
	FindByID(ctx context.Context, id string) (*entity.Product, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Product, error)
}

type ProductService interface {
	GetAll(ctx context.Context) (entity.Products, error)
}
