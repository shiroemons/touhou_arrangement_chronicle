package repository

import (
	"github.com/uptrace/bun"
)

type SongDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewSongDistributionServiceURLRepository(db *bun.DB) *SongDistributionServiceURLRepository {
	return &SongDistributionServiceURLRepository{db: db}
}
