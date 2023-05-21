package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SubEventRepository struct {
	db *bun.DB
}

func NewSubEventRepository(db *bun.DB) *SubEventRepository {
	return &SubEventRepository{db: db}
}

func (r *SubEventRepository) Create(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error) {
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

func (r *SubEventRepository) Update(ctx context.Context, subEvent *entity.SubEvent) (*entity.SubEvent, error) {
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

func (r *SubEventRepository) Delete(ctx context.Context, subEvent *entity.SubEvent) error {
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

func (r *SubEventRepository) FindByID(ctx context.Context, id string) (*entity.SubEvent, error) {
	subEvent := new(entity.SubEvent)
	err := r.db.NewSelect().Model(subEvent).
		Where("id = ?", id).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return subEvent, nil
}
