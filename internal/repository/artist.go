package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistRepository struct {
	db *bun.DB
}

func NewArtistRepository(db *bun.DB) *ArtistRepository {
	return &ArtistRepository{db: db}
}

func (r *ArtistRepository) Create(ctx context.Context, artist *entity.Artist) (*entity.Artist, error) {
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

func (r *ArtistRepository) Update(ctx context.Context, artist *entity.Artist) (*entity.Artist, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(artist).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return artist, nil
	}
	if _, err := r.db.NewUpdate().Model(artist).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return artist, nil
}

func (r *ArtistRepository) Delete(ctx context.Context, artist *entity.Artist) error {
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

func (r *ArtistRepository) FindByIDs(ctx context.Context, ids []string) (entity.Artists, error) {
	artists := make(entity.Artists, 0)
	err := r.db.NewSelect().Model(&artists).
		Where("a.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return artists, nil
}

func (r *ArtistRepository) FindByInitialType(ctx context.Context, initialType string) ([]*entity.Artist, error) {
	artists := make(entity.Artists, 0)

	err := r.db.NewSelect().Model(&artists).
		Where("initial_letter_type = ?", initialType).
		Order("name").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return artists, nil
}
