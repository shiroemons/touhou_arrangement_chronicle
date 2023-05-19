package repository

import (
	"github.com/uptrace/bun"
)

type SongVocalistRepository struct {
	db *bun.DB
}

func NewSongVocalistRepository(db *bun.DB) *SongVocalistRepository {
	return &SongVocalistRepository{db: db}
}
