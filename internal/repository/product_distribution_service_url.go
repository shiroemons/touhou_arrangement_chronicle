package repository

import (
	"github.com/uptrace/bun"
)

type ProductDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewProductDistributionServiceURLRepository(db *bun.DB) *ProductDistributionServiceURLRepository {
	return &ProductDistributionServiceURLRepository{db: db}
}
