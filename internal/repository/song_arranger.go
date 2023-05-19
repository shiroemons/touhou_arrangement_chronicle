package repository

import (
	"github.com/uptrace/bun"
)

type SongArrangerRepository struct {
	db *bun.DB
}

func NewSongArrangerRepository(db *bun.DB) *SongArrangerRepository {
	return &SongArrangerRepository{db: db}
}
