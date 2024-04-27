package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type AlbumTagRepository struct {
	db *bun.DB
}

func NewAlbumTagRepository(db *bun.DB) *AlbumTagRepository {
	return &AlbumTagRepository{db: db}
}

func (r *AlbumTagRepository) Add(ctx context.Context, tag *schema.AlbumTag) (*schema.AlbumTag, error) {
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

func (r *AlbumTagRepository) Remove(ctx context.Context, tag *schema.AlbumTag) error {
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
