package repository

import (
	"github.com/uptrace/bun"
)

type SongGenreRepository struct {
	db *bun.DB
}

func NewSongGenreRepository(db *bun.DB) *SongGenreRepository {
	return &SongGenreRepository{db: db}
}
