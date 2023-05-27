package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type GenreRepository struct {
	db *bun.DB
}

func NewGenreRepository(db *bun.DB) *GenreRepository {
	return &GenreRepository{db: db}
}

func (r *GenreRepository) Create(ctx context.Context, genre *entity.Genre) (*entity.Genre, error) {
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

func (r *GenreRepository) Update(ctx context.Context, genre *entity.Genre) (*entity.Genre, error) {
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

func (r *GenreRepository) Delete(ctx context.Context, genre *entity.Genre) error {
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

func (r *GenreRepository) FindAll(ctx context.Context) ([]*entity.Genre, error) {
	genres := make([]*entity.Genre, 0)
	if err := r.db.NewSelect().Model(&genres).Scan(ctx); err != nil {
		return nil, err
	}
	return genres, nil
}
