package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type SongGenreRepository struct {
	db *bun.DB
}

func NewSongGenreRepository(db *bun.DB) *SongGenreRepository {
	return &SongGenreRepository{db: db}
}

func (r *SongGenreRepository) Add(ctx context.Context, genre *schema.SongGenre) (*schema.SongGenre, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(genre).Exec(ctx); err != nil {
			return nil, err
		}
		return genre, nil
	}
	if _, err := r.db.NewInsert().Model(genre).Exec(ctx); err != nil {
		return nil, err
	}
	return genre, nil
}

func (r *SongGenreRepository) Remove(ctx context.Context, genre *schema.SongGenre) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(genre).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(genre).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
