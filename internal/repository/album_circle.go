package repository

import (
	"github.com/uptrace/bun"
)

type AlbumCircleRepository struct {
	db *bun.DB
}

func NewAlbumCircleRepository(db *bun.DB) *AlbumCircleRepository {
	return &AlbumCircleRepository{db: db}
}
