package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type ProductRepository interface {
	All(ctx context.Context) ([]*schema.Product, error)
	FindByIDs(ctx context.Context, ids []string) ([]*schema.Product, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Product, error)
}
