package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumRepository struct {
	db *bun.DB
}

func NewAlbumRepository(db *bun.DB) *AlbumRepository {
	return &AlbumRepository{db: db}
}

func (r *AlbumRepository) Create(ctx context.Context, album *entity.Album) (*entity.Album, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(album).Exec(ctx); err != nil {
			return nil, err
		}
		return album, nil
	}
	if _, err := r.db.NewInsert().Model(album).Exec(ctx); err != nil {
		return nil, err
	}
	return album, nil
}

func (r *AlbumRepository) Update(ctx context.Context, album *entity.Album) (*entity.Album, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(album).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return album, nil
	}
	if _, err := r.db.NewUpdate().Model(album).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return album, nil
}

func (r *AlbumRepository) Delete(ctx context.Context, album *entity.Album) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(album).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(album).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *AlbumRepository) FindByID(ctx context.Context, id string) (*entity.Album, error) {
	album := new(entity.Album)
	err := r.db.NewSelect().Model(album).
		Relation("Event").
		Relation("SubEvent").
		Relation("AlbumConsignmentShops").
		Relation("AlbumDistributionServiceURLs").
		Relation("AlbumUPCs").
		Relation("Songs").
		Relation("Circles").
		Relation("Genres").
		Relation("Genres.Genre").
		Relation("Tags").
		Relation("Tags.Tag").
		Where("al.id = ?", id).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return album, nil
}

// GetMapInIDs is get map in ids
func (r *AlbumRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Album, error) {
	albums := make([]*entity.Album, 0)
	err := r.db.NewSelect().Model(&albums).
		Relation("Event").
		Relation("SubEvent").
		Relation("AlbumConsignmentShops").
		Relation("AlbumDistributionServiceURLs").
		Relation("AlbumUPCs").
		Relation("Songs").
		Relation("Circles").
		Relation("Genres").
		Relation("Genres.Genre").
		Relation("Tags").
		Relation("Tags.Tag").
		Where("al.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}

	albumMap := make(map[string]*entity.Album, len(albums))
	for _, album := range albums {
		albumMap[album.ID] = album
	}

	return albumMap, nil
}
