package repository

import (
	"github.com/uptrace/bun"
)

type CircleRepository struct {
	db *bun.DB
}

func NewCircleRepository(db *bun.DB) *CircleRepository {
	return &CircleRepository{db: db}
}
