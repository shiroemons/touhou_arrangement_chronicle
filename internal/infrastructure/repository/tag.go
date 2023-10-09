package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type TagRepository struct {
	db *bun.DB
}

func NewTagRepository(db *bun.DB) *TagRepository {
	return &TagRepository{db: db}
}

func (r *TagRepository) Create(ctx context.Context, tag *entity.Tag) (*entity.Tag, error) {
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

func (r *TagRepository) Update(ctx context.Context, tag *entity.Tag) (*entity.Tag, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(tag).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return tag, nil
	}
	if _, err := r.db.NewUpdate().Model(tag).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return tag, nil
}

func (r *TagRepository) Delete(ctx context.Context, tag *entity.Tag) error {
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

func (r *TagRepository) FindAll(ctx context.Context) ([]*entity.Tag, error) {
	tags := make(entity.Tags, 0)
	if err := r.db.NewSelect().Model(&tags).Scan(ctx); err != nil {
		return nil, err
	}
	return tags, nil
}
