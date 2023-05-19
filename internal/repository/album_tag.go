package repository

import (
	"github.com/uptrace/bun"
)

type AlbumTagRepository struct {
	db *bun.DB
}

func NewAlbumTagRepository(db *bun.DB) *AlbumTagRepository {
	return &AlbumTagRepository{db: db}
}
