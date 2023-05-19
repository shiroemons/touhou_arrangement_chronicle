package repository

import (
	"github.com/uptrace/bun"
)

type AlbumUPCRepository struct {
	db *bun.DB
}

func NewAlbumUPCRepository(db *bun.DB) *AlbumUPCRepository {
	return &AlbumUPCRepository{db: db}
}
