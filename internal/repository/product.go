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

func (r *ProductRepository) FindByID(ctx context.Context, id string) (*entity.Product, error) {
	product := new(entity.Product)
	err := r.db.NewSelect().Model(product).
		Where("id = ?", id).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return product, nil
}
