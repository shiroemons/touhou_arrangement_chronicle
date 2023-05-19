package repository

import (
	"github.com/uptrace/bun"
)

type SongCircleRepository struct {
	db *bun.DB
}

func NewSongCircleRepository(db *bun.DB) *SongCircleRepository {
	return &SongCircleRepository{db: db}
}
