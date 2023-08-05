package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventRepository interface {
	Create(ctx context.Context, event *entity.Event) (*entity.Event, error)
	Update(ctx context.Context, event *entity.Event) (*entity.Event, error)
	Delete(ctx context.Context, event *entity.Event) error
	FindByIDs(ctx context.Context, ids []string) (entity.Events, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Event, error)
}

type EventService interface {
	GetEventsByIDs(ctx context.Context, ids []string) (entity.Events, error)
}
