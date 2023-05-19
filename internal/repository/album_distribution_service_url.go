package repository

import (
	"github.com/uptrace/bun"
)

type AlbumDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewAlbumDistributionServiceURLRepository(db *bun.DB) *AlbumDistributionServiceURLRepository {
	return &AlbumDistributionServiceURLRepository{db: db}
}
