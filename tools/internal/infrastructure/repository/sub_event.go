package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type SubEventRepository struct {
	db *bun.DB
}

func NewSubEventRepository(db *bun.DB) *SubEventRepository {
	return &SubEventRepository{db: db}
}

func (r *SubEventRepository) Create(ctx context.Context, subEvent *schema.SubEvent) (*schema.SubEvent, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(subEvent).Exec(ctx); err != nil {
			return nil, err
		}
		return subEvent, nil
	}
	if _, err := r.db.NewInsert().Model(subEvent).Exec(ctx); err != nil {
		return nil, err
	}
	return subEvent, nil
}

func (r *SubEventRepository) Update(ctx context.Context, subEvent *schema.SubEvent) (*schema.SubEvent, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(subEvent).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return subEvent, nil
	}
	if _, err := r.db.NewUpdate().Model(subEvent).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return subEvent, nil
}

func (r *SubEventRepository) Delete(ctx context.Context, subEvent *schema.SubEvent) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(subEvent).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(subEvent).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *SubEventRepository) FindByIDs(ctx context.Context, ids []string) ([]*schema.SubEvent, error) {
	subEvents := make([]*schema.SubEvent, 0)
	err := r.db.NewSelect().Model(&subEvents).
		Where("se.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return subEvents, nil
}

// GetMapInIDs は、指定したIDのSubEventを取得します。
func (r *SubEventRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*schema.SubEvent, error) {
	subEvents := make([]*schema.SubEvent, 0)
	err := r.db.NewSelect().Model(&subEvents).
		Where("id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	subEventMap := make(map[string]*schema.SubEvent, len(subEvents))
	for _, v := range subEvents {
		subEventMap[v.ID] = v
	}
	return subEventMap, nil
}
