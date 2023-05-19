package repository

import (
	"github.com/uptrace/bun"
)

type SongLyricistRepository struct {
	db *bun.DB
}

func NewSongLyricistRepository(db *bun.DB) *SongLyricistRepository {
	return &SongLyricistRepository{db: db}
}
