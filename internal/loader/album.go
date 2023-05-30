package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"

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
func (l *AlbumLoader) BatchGetAlbums(ctx context.Context, keys []string) []*dataloader.Result[*entity.Album] {
	albumByID, err := l.aRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*entity.Album], len(keys))
	for index, key := range keys {
		if album, ok := albumByID[key]; ok {
			output[index] = &dataloader.Result[*entity.Album]{Data: album, Error: nil}
		} else {
			err = fmt.Errorf("album not found %s", key)
			output[index] = &dataloader.Result[*entity.Album]{Data: nil, Error: err}
		}
	}
	return output
}

// LoadAlbum は Album を dataloader から取得します。
func LoadAlbum(ctx context.Context, albumID string) (*model.Album, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.aLoader.Load(ctx, albumID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
