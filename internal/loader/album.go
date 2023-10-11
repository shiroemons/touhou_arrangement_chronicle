package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	repository2 "github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/infrastructure/repository"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type AlbumLoader struct {
	aRepo repository2.AlbumRepository
}

func AlbumLoaderProvider(db *bun.DB) *AlbumLoader {
	aRepo := repository.NewAlbumRepository(db)
	return &AlbumLoader{aRepo: aRepo}
}

// BatchGetAlbums は dataloader の BatchGetAlbums に渡す関数です。
func (l *AlbumLoader) BatchGetAlbums(ctx context.Context, keys []string) []*dataloader.Result[*schema.Album] {
	albumByID, err := l.aRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*schema.Album], len(keys))
	for index, key := range keys {
		if album, ok := albumByID[key]; ok {
			output[index] = &dataloader.Result[*schema.Album]{Data: album, Error: nil}
		} else {
			err = fmt.Errorf("album not found %s", key)
			output[index] = &dataloader.Result[*schema.Album]{Data: nil, Error: err}
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
