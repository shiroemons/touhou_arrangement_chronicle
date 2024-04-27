package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type OriginalSongRepository struct {
	db *bun.DB
}

func NewOriginalSongRepository(db *bun.DB) *OriginalSongRepository {
	return &OriginalSongRepository{db: db}
}

func (r *OriginalSongRepository) All(ctx context.Context) ([]*schema.OriginalSong, error) {
	originalSongs := make([]*schema.OriginalSong, 0)
	err := r.db.NewSelect().Model(&originalSongs).
		Relation("Product").
		Relation("Product.ProductDistributionServiceURLs").
		Relation("OriginalSongDistributionServiceURLs").
		Order("id ASC").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return originalSongs, nil
}

func (r *OriginalSongRepository) FindByIDs(ctx context.Context, ids []string) ([]*schema.OriginalSong, error) {
	originalSongs := make([]*schema.OriginalSong, 0)
	err := r.db.NewSelect().Model(originalSongs).
		Relation("Product").
		Relation("Product.ProductDistributionServiceURLs").
		Relation("OriginalSongDistributionServiceURLs").
		Where("os.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return originalSongs, nil
}
