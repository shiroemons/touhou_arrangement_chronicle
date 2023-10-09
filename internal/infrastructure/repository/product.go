package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductRepository struct {
	db *bun.DB
}

func NewProductRepository(db *bun.DB) *ProductRepository {
	return &ProductRepository{db: db}
}

func (r *ProductRepository) All(ctx context.Context) ([]*entity.Product, error) {
	products := make([]*entity.Product, 0)
	err := r.db.NewSelect().Model(&products).
		Relation("OriginalSongs").
		Relation("ProductDistributionServiceURLs").
		Order("id ASC").Scan(ctx)
	if err != nil {
		return nil, err
	}
	return products, nil
}

func (r *ProductRepository) FindByIDs(ctx context.Context, ids []string) (entity.Products, error) {
	products := make(entity.Products, 0)
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

func (r *ProductRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Product, error) {
	products := make([]*entity.Product, 0)
	err := r.db.NewSelect().Model(&products).
		Relation("OriginalSongs").
		Relation("ProductDistributionServiceURLs").
		Where("id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	productMap := make(map[string]*entity.Product, len(products))
	for _, v := range products {
		productMap[v.ID] = v
	}
	return productMap, nil
}
