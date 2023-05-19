package repository

import (
	"github.com/uptrace/bun"
)

type SongTagRepository struct {
	db *bun.DB
}

func NewSongTagRepository(db *bun.DB) *SongTagRepository {
	return &SongTagRepository{db: db}
}
