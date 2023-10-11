package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SubEventRepository interface {
	Create(ctx context.Context, subEvent *schema.SubEvent) (*schema.SubEvent, error)
	Update(ctx context.Context, subEvent *schema.SubEvent) (*schema.SubEvent, error)
	Delete(ctx context.Context, subEvent *schema.SubEvent) error
	FindByIDs(ctx context.Context, ids []string) (schema.SubEvents, error)
	GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.SubEvent, error)
}
