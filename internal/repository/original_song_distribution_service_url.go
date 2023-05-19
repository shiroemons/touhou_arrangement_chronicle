package repository

import (
	"github.com/uptrace/bun"
)

type OriginalSongDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewOriginalSongDistributionServiceURLRepository(db *bun.DB) *OriginalSongDistributionServiceURLRepository {
	return &OriginalSongDistributionServiceURLRepository{db: db}
}
