package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type SongArrangeCircleRepository struct {
	db *bun.DB
}

func NewSongArrangeCircleRepository(db *bun.DB) *SongArrangeCircleRepository {
	return &SongArrangeCircleRepository{db: db}
}

func (r *SongArrangeCircleRepository) Add(ctx context.Context, circle *schema.SongArrangeCircle) (*schema.SongArrangeCircle, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(circle).Exec(ctx); err != nil {
			return nil, err
		}
		return circle, nil
	}
	if _, err := r.db.NewInsert().Model(circle).Exec(ctx); err != nil {
		return nil, err
	}
	return circle, nil
}

func (r *SongArrangeCircleRepository) Remove(ctx context.Context, circle *schema.SongArrangeCircle) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(circle).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(circle).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
