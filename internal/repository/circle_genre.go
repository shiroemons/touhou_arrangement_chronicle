package repository

import (
	"github.com/uptrace/bun"
)

type CircleGenreRepository struct {
	db *bun.DB
}

func NewCircleGenreRepository(db *bun.DB) *CircleGenreRepository {
	return &CircleGenreRepository{db: db}
}
