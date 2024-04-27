package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type SongRearrangerRepository struct {
	db *bun.DB
}

func NewSongRearrangerRepository(db *bun.DB) *SongRearrangerRepository {
	return &SongRearrangerRepository{db: db}
}

func (r *SongRearrangerRepository) Add(ctx context.Context, artist *schema.SongRearranger) (*schema.SongRearranger, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(artist).Exec(ctx); err != nil {
			return nil, err
		}
		return artist, nil
	}
	if _, err := r.db.NewInsert().Model(artist).Exec(ctx); err != nil {
		return nil, err
	}
	return artist, nil
}

func (r *SongRearrangerRepository) Remove(ctx context.Context, artist *schema.SongRearranger) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(artist).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(artist).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
