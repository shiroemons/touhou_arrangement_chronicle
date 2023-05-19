package repository

import (
	"github.com/uptrace/bun"
)

type AlbumConsignmentShopRepository struct {
	db *bun.DB
}

func NewAlbumConsignmentShopRepository(db *bun.DB) *AlbumConsignmentShopRepository {
	return &AlbumConsignmentShopRepository{db: db}
}
