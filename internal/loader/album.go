package loader

import (
	"context"

	"github.com/graph-gophers/dataloader"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumLoader struct {
	aRepo domain.AlbumRepository
}

func AlbumLoaderProvider(aRepo domain.AlbumRepository) *AlbumLoader {
	return &AlbumLoader{aRepo: aRepo}
}

// BatchGetAlbums は dataloader の BatchGetAlbums に渡す関数です。
func (l *AlbumLoader) BatchGetAlbums(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	albumIDs := make([]string, len(keys))
	for ix, key := range keys {
		albumIDs[ix] = key.String()
	}

	albumByID, err := l.aRepo.GetMapInIDs(ctx, albumIDs)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, albumKey := range keys {
		event, ok := albumByID[albumKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: event, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

// LoadAlbum は Album を dataloader から取得します。
func LoadAlbum(ctx context.Context, albumID string) (*model.Album, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.aLoader.Load(ctx, dataloader.StringKey(albumID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	album := result.(*entity.Album)
	return album.ToGraphQL(), nil
}
