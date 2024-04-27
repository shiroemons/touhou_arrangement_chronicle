package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type EventRepository interface {
	Create(ctx context.Context, event *schema.Event) (*schema.Event, error)
	Update(ctx context.Context, event *schema.Event) (*schema.Event, error)
	Delete(ctx context.Context, event *schema.Event) error
	FindByIDs(ctx context.Context, ids []string) ([]*schema.Event, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Event, error)
}
