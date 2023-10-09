package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/uptrace/bun"
)

type GenreRepository struct {
	db *bun.DB
}

func NewGenreRepository(db *bun.DB) *GenreRepository {
	return &GenreRepository{db: db}
}

func (r *GenreRepository) Create(ctx context.Context, genre *schema.Genre) (*schema.Genre, error) {
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

func (r *GenreRepository) Update(ctx context.Context, genre *schema.Genre) (*schema.Genre, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(genre).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return genre, nil
	}
	if _, err := r.db.NewUpdate().Model(genre).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return genre, nil
}

func (r *GenreRepository) Delete(ctx context.Context, genre *schema.Genre) error {
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

func (r *GenreRepository) FindAll(ctx context.Context) ([]*schema.Genre, error) {
	genres := make([]*schema.Genre, 0)
	if err := r.db.NewSelect().Model(&genres).Scan(ctx); err != nil {
		return nil, err
	}
	return genres, nil
}
