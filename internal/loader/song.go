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

type SongLoader struct {
	sRepo repository2.SongRepository
}

func SongLoaderProvider(db *bun.DB) *SongLoader {
	sRepo := repository.NewSongRepository(db)
	return &SongLoader{sRepo: sRepo}
}

func (l *SongLoader) BatchGetSongs(ctx context.Context, keys []string) []*dataloader.Result[*schema.Song] {
	songByID, err := l.sRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*schema.Song], len(keys))
	for index, key := range keys {
		song, ok := songByID[key]
		if ok {
			output[index] = &dataloader.Result[*schema.Song]{Data: song, Error: nil}
		} else {
			err = fmt.Errorf("song not found %s", key)
			output[index] = &dataloader.Result[*schema.Song]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadSong(ctx context.Context, songID string) (*model.Song, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.sLoader.Load(ctx, songID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
