package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongISRCRepository struct {
	db *bun.DB
}

func NewSongISRCRepository(db *bun.DB) *SongISRCRepository {
	return &SongISRCRepository{db: db}
}

func (r *SongISRCRepository) Add(ctx context.Context, isrc *schema.SongISRC) (*schema.SongISRC, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(isrc).Exec(ctx); err != nil {
			return nil, err
		}
		return isrc, nil
	}
	if _, err := r.db.NewInsert().Model(isrc).Exec(ctx); err != nil {
		return nil, err
	}
	return isrc, nil
}

func (r *SongISRCRepository) Remove(ctx context.Context, isrc *schema.SongISRC) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(isrc).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(isrc).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
