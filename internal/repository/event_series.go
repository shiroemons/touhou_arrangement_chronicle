package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventSeriesRepository struct {
	db *bun.DB
}

func NewEventSeriesRepository(db *bun.DB) *EventSeriesRepository {
	return &EventSeriesRepository{db: db}
}

func (r *EventSeriesRepository) Create(ctx context.Context, eventSeries *entity.EventSeries) (*entity.EventSeries, error) {
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

func (r *EventSeriesRepository) Update(ctx context.Context, eventSeries *entity.EventSeries) (*entity.EventSeries, error) {
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

func (r *EventSeriesRepository) Delete(ctx context.Context, eventSeries *entity.EventSeries) error {
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

func (r *EventSeriesRepository) FindByID(ctx context.Context, id string) (*entity.EventSeries, error) {
	eventSeries := new(entity.EventSeries)
	err := r.db.NewSelect().Model(eventSeries).
		Where("id = ?", id).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) All(ctx context.Context) ([]*entity.EventSeries, error) {
	eventSeries := make([]*entity.EventSeries, 0)
	err := r.db.NewSelect().Model(&eventSeries).
		Relation("Events").
		Relation("Events.SubEvents").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return eventSeries, nil
}

func (r *EventSeriesRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.EventSeries, error) {
	eventSeries := make([]*entity.EventSeries, 0)
	err := r.db.NewSelect().Model(&eventSeries).
		Relation("Events").
		Relation("Events.SubEvents").
		Where("es.id IN (?)", ids).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	eventSeriesMap := make(map[string]*entity.EventSeries)
	for _, v := range eventSeries {
		eventSeriesMap[v.ID] = v
	}
	return eventSeriesMap, nil
}
