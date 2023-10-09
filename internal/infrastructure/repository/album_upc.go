package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type AlbumUPCRepository struct {
	db *bun.DB
}

func NewAlbumUPCRepository(db *bun.DB) *AlbumUPCRepository {
	return &AlbumUPCRepository{db: db}
}

func (r *AlbumUPCRepository) Add(ctx context.Context, upc *schema.AlbumUPC) (*schema.AlbumUPC, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(upc).Exec(ctx); err != nil {
			return nil, err
		}
		return upc, nil
	}
	if _, err := r.db.NewInsert().Model(upc).Exec(ctx); err != nil {
		return nil, err
	}
	return upc, nil
}

func (r *AlbumUPCRepository) Remove(ctx context.Context, upc *schema.AlbumUPC) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(upc).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(upc).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
