package repository

import (
	"github.com/uptrace/bun"
)

type SongRepository struct {
	db *bun.DB
}

func NewSongRepository(db *bun.DB) *SongRepository {
	return &SongRepository{db: db}
}
