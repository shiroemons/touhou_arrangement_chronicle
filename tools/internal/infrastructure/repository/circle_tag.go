package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type CircleTagRepository struct {
	db *bun.DB
}

func NewCircleTagRepository(db *bun.DB) *CircleTagRepository {
	return &CircleTagRepository{db: db}
}

func (r *CircleTagRepository) Add(ctx context.Context, tag *schema.CircleTag) (*schema.CircleTag, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(tag).Exec(ctx); err != nil {
			return nil, err
		}
		return tag, nil
	}
	if _, err := r.db.NewInsert().Model(tag).Exec(ctx); err != nil {
		return nil, err
	}
	return tag, nil
}

func (r *CircleTagRepository) Remove(ctx context.Context, tag *schema.CircleTag) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(tag).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(tag).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
