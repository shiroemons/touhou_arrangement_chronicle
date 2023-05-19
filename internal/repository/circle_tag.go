package repository

import (
	"github.com/uptrace/bun"
)

type CircleTagRepository struct {
	db *bun.DB
}

func NewCircleTagRepository(db *bun.DB) *CircleTagRepository {
	return &CircleTagRepository{db: db}
}
