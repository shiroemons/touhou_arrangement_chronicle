package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type EventSeriesRepository struct {
	db *bun.DB
}

func NewEventSeriesRepository(db *bun.DB) *EventSeriesRepository {
	return &EventSeriesRepository{db: db}
}

func (r *EventSeriesRepository) Create(ctx context.Context, eventSeries *schema.EventSeries) (*schema.EventSeries, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(eventSeries).Exec(ctx); err != nil {
			return nil, err
		}
		return eventSeries, nil
	}
	if _, err := r.db.NewInsert().Model(eventSeries).Exec(ctx); err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) Update(ctx context.Context, eventSeries *schema.EventSeries) (*schema.EventSeries, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(eventSeries).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return eventSeries, nil
	}
	if _, err := r.db.NewUpdate().Model(eventSeries).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) Delete(ctx context.Context, eventSeries *schema.EventSeries) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(eventSeries).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(eventSeries).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *EventSeriesRepository) FindByIDs(ctx context.Context, ids []string) ([]*schema.EventSeries, error) {
	eventSeries := make([]*schema.EventSeries, 0)
	err := r.db.NewSelect().Model(&eventSeries).
		Relation("Events").
		Relation("Events.SubEvents").
		Where("es.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) All(ctx context.Context) ([]*schema.EventSeries, error) {
	eventSeries := make([]*schema.EventSeries, 0)
	err := r.db.NewSelect().Model(&eventSeries).
		Relation("Events", func(q *bun.SelectQuery) *bun.SelectQuery {
			return q.Order("e.event_dates DESC")
		}).
		Relation("Events.SubEvents").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.EventSeries, error) {
	eventSeries := make([]*schema.EventSeries, 0)
	err := r.db.NewSelect().Model(&eventSeries).
		Relation("Events", func(q *bun.SelectQuery) *bun.SelectQuery {
			return q.Order("e.event_dates DESC")
		}).
		Relation("Events.SubEvents").
		Where("es.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	eventSeriesMap := make(map[string]*schema.EventSeries, len(eventSeries))
	for _, v := range eventSeries {
		eventSeriesMap[v.ID] = v
	}
	return eventSeriesMap, nil
}
