package repository

import (
	"github.com/uptrace/bun"
)

type SubEventRepository struct {
	db *bun.DB
}

func NewSubEventRepository(db *bun.DB) *SubEventRepository {
	return &SubEventRepository{db: db}
}
