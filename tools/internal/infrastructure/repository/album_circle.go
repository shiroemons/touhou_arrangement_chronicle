package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type AlbumCircleRepository struct {
	db *bun.DB
}

func NewAlbumCircleRepository(db *bun.DB) *AlbumCircleRepository {
	return &AlbumCircleRepository{db: db}
}

func (r *AlbumCircleRepository) Add(ctx context.Context, circle *schema.AlbumCircle) (*schema.AlbumCircle, error) {
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

func (r *AlbumCircleRepository) Remove(ctx context.Context, circle *schema.AlbumCircle) error {
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
