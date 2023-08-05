package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongRepository struct {
	db *bun.DB
}

func NewSongRepository(db *bun.DB) *SongRepository {
	return &SongRepository{db: db}
}

func (r *SongRepository) Create(ctx context.Context, song *entity.Song) (*entity.Song, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(song).Exec(ctx); err != nil {
			return nil, err
		}
		return song, nil
	}
	if _, err := r.db.NewInsert().Model(song).Exec(ctx); err != nil {
		return nil, err
	}
	return song, nil
}

func (r *SongRepository) Update(ctx context.Context, song *entity.Song) (*entity.Song, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(song).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return song, nil
	}
	if _, err := r.db.NewUpdate().Model(song).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return song, nil
}

func (r *SongRepository) Delete(ctx context.Context, song *entity.Song) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(song).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(song).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *SongRepository) FindByIDs(ctx context.Context, ids []string) (entity.Songs, error) {
	songs := make(entity.Songs, 0)
	err := r.db.NewSelect().Model(&songs).
		Relation("SongDistributionServiceURLs").
		Relation("SongISRCs").
		Relation("Genres.Genre").
		Relation("Tags.Tag").
		Relation("OriginalSongs").
		Relation("ArrangeCircles").
		Relation("Arrangers").
		Relation("Composers").
		Relation("Lyricists").
		Relation("ReArrangers").
		Relation("Vocalists").
		Where("s.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return songs, nil
}

// GetMapInIDs は、指定したIDの曲を取得します。
func (r *SongRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Song, error) {
	songs := make([]*entity.Song, 0)
	err := r.db.NewSelect().Model(&songs).
		Relation("SongDistributionServiceURLs").
		Relation("SongISRCs").
		Relation("Genres.Genre").
		Relation("Tags.Tag").
		Relation("OriginalSongs").
		Relation("ArrangeCircles").
		Relation("Arrangers").
		Relation("Composers").
		Relation("Lyricists").
		Relation("ReArrangers").
		Relation("Vocalists").
		Where("s.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	songMap := make(map[string]*entity.Song, len(songs))
	for _, v := range songs {
		songMap[v.ID] = v
	}
	return songMap, nil
}
