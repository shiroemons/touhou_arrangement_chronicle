package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongOriginalSongRepository struct {
	db *bun.DB
}

func NewSongOriginalSongRepository(db *bun.DB) *SongOriginalSongRepository {
	return &SongOriginalSongRepository{db: db}
}

func (r *SongOriginalSongRepository) Add(ctx context.Context, originalSong *entity.SongOriginalSong) (*entity.SongOriginalSong, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(originalSong).Exec(ctx); err != nil {
			return nil, err
		}
		return originalSong, nil
	}
	if _, err := r.db.NewInsert().Model(originalSong).Exec(ctx); err != nil {
		return nil, err
	}
	return originalSong, nil
}

func (r *SongOriginalSongRepository) Remove(ctx context.Context, originalSong *entity.SongOriginalSong) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(originalSong).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(originalSong).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}
