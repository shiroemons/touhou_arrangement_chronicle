package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type AlbumDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewAlbumDistributionServiceURLRepository(db *bun.DB) *AlbumDistributionServiceURLRepository {
	return &AlbumDistributionServiceURLRepository{db: db}
}

func (r *AlbumDistributionServiceURLRepository) Add(ctx context.Context, serviceURL *schema.AlbumDistributionServiceURL) (*schema.AlbumDistributionServiceURL, error) {
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

func (r *AlbumDistributionServiceURLRepository) Remove(ctx context.Context, serviceURL *schema.AlbumDistributionServiceURL) error {
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
