package repository

import (
	"github.com/uptrace/bun"
)

type AlbumRepository struct {
	db *bun.DB
}

func NewAlbumRepository(db *bun.DB) *AlbumRepository {
	return &AlbumRepository{db: db}
}
