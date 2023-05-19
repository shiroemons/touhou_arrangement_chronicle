package repository

import (
	"github.com/uptrace/bun"
)

type AlbumGenreRepository struct {
	db *bun.DB
}

func NewAlbumGenreRepository(db *bun.DB) *AlbumGenreRepository {
	return &AlbumGenreRepository{db: db}
}
