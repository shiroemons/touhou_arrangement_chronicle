package repository

import (
	"github.com/uptrace/bun"
)

type EventRepository struct {
	db *bun.DB
}

func NewEventRepository(db *bun.DB) *EventRepository {
	return &EventRepository{db: db}
}
