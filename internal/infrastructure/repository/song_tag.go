package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongTagRepository struct {
	db *bun.DB
}

func NewSongTagRepository(db *bun.DB) *SongTagRepository {
	return &SongTagRepository{db: db}
}

func (r *SongTagRepository) Add(ctx context.Context, tag *entity.SongTag) (*entity.SongTag, error) {
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

func (r *SongTagRepository) Remove(ctx context.Context, tag *entity.SongTag) error {
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
