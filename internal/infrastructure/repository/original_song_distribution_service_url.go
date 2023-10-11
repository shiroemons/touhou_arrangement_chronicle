package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type OriginalSongDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewOriginalSongDistributionServiceURLRepository(db *bun.DB) *OriginalSongDistributionServiceURLRepository {
	return &OriginalSongDistributionServiceURLRepository{db: db}
}

func (r *OriginalSongDistributionServiceURLRepository) Add(ctx context.Context, serviceURL *schema.OriginalSongDistributionServiceURL) (*schema.OriginalSongDistributionServiceURL, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(serviceURL).Exec(ctx); err != nil {
			return nil, err
		}
		return serviceURL, nil
	}
	if _, err := r.db.NewInsert().Model(serviceURL).Exec(ctx); err != nil {
		return nil, err
	}
	return serviceURL, nil
}

func (r *OriginalSongDistributionServiceURLRepository) Remove(ctx context.Context, serviceURL *schema.OriginalSongDistributionServiceURL) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(serviceURL).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(serviceURL).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
