package repository

import (
	"github.com/uptrace/bun"
)

type EventSeriesRepository struct {
	db *bun.DB
}

func NewEventSeriesRepository(db *bun.DB) *EventSeriesRepository {
	return &EventSeriesRepository{db: db}
}
