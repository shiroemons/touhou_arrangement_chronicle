package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type ProductDistributionServiceURLRepository struct {
	db *bun.DB
}

func NewProductDistributionServiceURLRepository(db *bun.DB) *ProductDistributionServiceURLRepository {
	return &ProductDistributionServiceURLRepository{db: db}
}

func (r *ProductDistributionServiceURLRepository) Add(ctx context.Context, serviceURL *schema.ProductDistributionServiceURL) (*schema.ProductDistributionServiceURL, error) {
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

func (r *ProductDistributionServiceURLRepository) Remove(ctx context.Context, serviceURL *schema.ProductDistributionServiceURL) error {
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
