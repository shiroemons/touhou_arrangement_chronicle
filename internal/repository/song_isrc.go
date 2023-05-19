package repository

import (
	"github.com/uptrace/bun"
)

type SongISRCRepository struct {
	db *bun.DB
}

func NewSongISRCRepository(db *bun.DB) *SongISRCRepository {
	return &SongISRCRepository{db: db}
}
