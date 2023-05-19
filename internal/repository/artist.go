package repository

import (
	"github.com/uptrace/bun"
)

type ArtistRepository struct {
	db *bun.DB
}

func NewArtistRepository(db *bun.DB) *ArtistRepository {
	return &ArtistRepository{db: db}
}
