package repository

import (
	"github.com/uptrace/bun"
)

type SongOriginalSongRepository struct {
	db *bun.DB
}

func NewSongOriginalSongRepository(db *bun.DB) *SongOriginalSongRepository {
	return &SongOriginalSongRepository{db: db}
}
