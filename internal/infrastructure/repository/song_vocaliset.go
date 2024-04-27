package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type SongVocalistRepository struct {
	db *bun.DB
}

func NewSongVocalistRepository(db *bun.DB) *SongVocalistRepository {
	return &SongVocalistRepository{db: db}
}

func (r *SongVocalistRepository) Add(ctx context.Context, artist *schema.SongVocalist) (*schema.SongVocalist, error) {
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

func (r *SongVocalistRepository) Remove(ctx context.Context, artist *schema.SongVocalist) error {
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
