package repository

import (
	"github.com/uptrace/bun"
)

type GenreRepository struct {
	db *bun.DB
}

func NewGenreRepository(db *bun.DB) *GenreRepository {
	return &GenreRepository{db: db}
}
