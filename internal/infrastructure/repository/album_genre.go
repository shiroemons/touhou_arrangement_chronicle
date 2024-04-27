package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type AlbumGenreRepository struct {
	db *bun.DB
}

func NewAlbumGenreRepository(db *bun.DB) *AlbumGenreRepository {
	return &AlbumGenreRepository{db: db}
}

func (r *AlbumGenreRepository) Add(ctx context.Context, genre *schema.AlbumGenre) (*schema.AlbumGenre, error) {
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

func (r *AlbumGenreRepository) Remove(ctx context.Context, genre *schema.AlbumGenre) error {
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
