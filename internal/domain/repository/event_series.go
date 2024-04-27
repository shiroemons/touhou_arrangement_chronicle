package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type EventSeriesRepository interface {
	Create(ctx context.Context, eventSeries *schema.EventSeries) (*schema.EventSeries, error)
	Update(ctx context.Context, eventSeries *schema.EventSeries) (*schema.EventSeries, error)
	Delete(ctx context.Context, eventSeries *schema.EventSeries) error
	FindByIDs(ctx context.Context, ids []string) ([]*schema.EventSeries, error)
	All(ctx context.Context) ([]*schema.EventSeries, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.EventSeries, error)
}
