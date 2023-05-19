package repository

import (
	"github.com/uptrace/bun"
)

type SongRearrangerRepository struct {
	db *bun.DB
}

func NewSongRearrangerRepository(db *bun.DB) *SongRearrangerRepository {
	return &SongRearrangerRepository{db: db}
}
