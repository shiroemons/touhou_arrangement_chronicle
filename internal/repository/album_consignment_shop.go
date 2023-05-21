package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumConsignmentShopRepository struct {
	db *bun.DB
}

func NewAlbumConsignmentShopRepository(db *bun.DB) *AlbumConsignmentShopRepository {
	return &AlbumConsignmentShopRepository{db: db}
}

func (r *AlbumConsignmentShopRepository) Add(ctx context.Context, shop *entity.AlbumConsignmentShop) (*entity.AlbumConsignmentShop, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(shop).Exec(ctx); err != nil {
			return nil, err
		}
		return shop, nil
	}
	if _, err := r.db.NewInsert().Model(shop).Exec(ctx); err != nil {
		return nil, err
	}
	return shop, nil
}

func (r *AlbumConsignmentShopRepository) Remove(ctx context.Context, shop *entity.AlbumConsignmentShop) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(shop).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(shop).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
