package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventSeriesRepository interface {
	Create(ctx context.Context, eventSeries *entity.EventSeries) (*entity.EventSeries, error)
	Update(ctx context.Context, eventSeries *entity.EventSeries) (*entity.EventSeries, error)
	Delete(ctx context.Context, eventSeries *entity.EventSeries) error
	FindByIDs(ctx context.Context, ids []string) (entity.EventSeriesArr, error)
	All(ctx context.Context) ([]*entity.EventSeries, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.EventSeries, error)
}

type EventSeriesService interface {
	GetAll(ctx context.Context) (entity.EventSeriesArr, error)
	GetEventSeriesByIDs(ctx context.Context, ids []string) (entity.EventSeriesArr, error)
}
