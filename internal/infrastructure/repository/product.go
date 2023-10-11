package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type ProductRepository struct {
	db *bun.DB
}

func NewProductRepository(db *bun.DB) *ProductRepository {
	return &ProductRepository{db: db}
}

func (r *ProductRepository) All(ctx context.Context) ([]*schema.Product, error) {
	products := make([]*schema.Product, 0)
	err := r.db.NewSelect().Model(&products).
		Relation("OriginalSongs").
		Relation("ProductDistributionServiceURLs").
		Order("id ASC").Scan(ctx)
	if err != nil {
		return nil, err
	}
	return products, nil
}

func (r *ProductRepository) FindByIDs(ctx context.Context, ids []string) (schema.Products, error) {
	products := make(schema.Products, 0)
	err := r.db.NewSelect().Model(&products).
		Relation("OriginalSongs").
		Relation("ProductDistributionServiceURLs").
		Where("p.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return products, nil
}

func (r *ProductRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Product, error) {
	products := make([]*schema.Product, 0)
	err := r.db.NewSelect().Model(&products).
		Relation("OriginalSongs").
		Relation("ProductDistributionServiceURLs").
		Where("id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	productMap := make(map[string]*schema.Product, len(products))
	for _, v := range products {
		productMap[v.ID] = v
	}
	return productMap, nil
}
