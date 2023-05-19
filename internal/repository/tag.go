package repository

import (
	"github.com/uptrace/bun"
)

type TagRepository struct {
	db *bun.DB
}

func NewTagRepository(db *bun.DB) *TagRepository {
	return &TagRepository{db: db}
}
