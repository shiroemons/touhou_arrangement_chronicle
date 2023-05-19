package repository

import (
	"github.com/uptrace/bun"
)

type SongArrangeCircleRepository struct {
	db *bun.DB
}

func NewSongArrangeCircleRepository(db *bun.DB) *SongArrangeCircleRepository {
	return &SongArrangeCircleRepository{db: db}
}
