package repository

import (
	"github.com/uptrace/bun"
)

type ProductRepository struct {
	db *bun.DB
}

func NewProductRepository(db *bun.DB) *ProductRepository {
	return &ProductRepository{db: db}
}
