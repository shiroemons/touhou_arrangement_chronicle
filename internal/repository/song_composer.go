package repository

import (
	"github.com/uptrace/bun"
)

type SongComposerRepository struct {
	db *bun.DB
}

func NewSongComposerRepository(db *bun.DB) *SongComposerRepository {
	return &SongComposerRepository{db: db}
}
