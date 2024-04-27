package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type EventRepository struct {
	db *bun.DB
}

func NewEventRepository(db *bun.DB) *EventRepository {
	return &EventRepository{db: db}
}

func (r *EventRepository) Create(ctx context.Context, event *schema.Event) (*schema.Event, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(event).Exec(ctx); err != nil {
			return nil, err
		}
		return event, nil
	}
	if _, err := r.db.NewInsert().Model(event).Exec(ctx); err != nil {
		return nil, err
	}
	return event, nil
}

func (r *EventRepository) Update(ctx context.Context, event *schema.Event) (*schema.Event, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(event).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return event, nil
	}
	if _, err := r.db.NewUpdate().Model(event).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return event, nil
}

func (r *EventRepository) Delete(ctx context.Context, event *schema.Event) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(event).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(event).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *EventRepository) FindByIDs(ctx context.Context, ids []string) ([]*schema.Event, error) {
	events := make([]*schema.Event, 0)
	err := r.db.NewSelect().Model(&events).
		Relation("EventSeries").
		Where("e.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return events, nil
}

func (r *EventRepository) All(ctx context.Context) ([]*schema.Event, error) {
	events := make([]*schema.Event, 0)
	err := r.db.NewSelect().Model(&events).
		Relation("SubEvents").
		Order("event_dates DESC").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return events, nil
}

// GetMapInIDs returns a map of events that match the specified IDs.
func (r *EventRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.Event, error) {
	events := make([]*schema.Event, 0)
	err := r.db.NewSelect().Model(&events).
		Relation("EventSeries").
		Where("e.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	eventMap := make(map[string]*schema.Event, len(events))
	for _, v := range events {
		eventMap[v.ID] = v
	}
	return eventMap, nil
}
