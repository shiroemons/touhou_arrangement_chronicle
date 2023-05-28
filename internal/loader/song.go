package loader

import (
	"context"

	"github.com/graph-gophers/dataloader"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongLoader struct {
	sRepo domain.SongRepository
}

func SongLoaderProvider(sRepo domain.SongRepository) *SongLoader {
	return &SongLoader{sRepo: sRepo}
}

func (l *SongLoader) BatchGetSongs(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	songIDs := make([]string, len(keys))
	for ix, key := range keys {
		songIDs[ix] = key.String()
	}

	songByID, err := l.sRepo.GetMapInIDs(ctx, songIDs)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, songKey := range keys {
		song, ok := songByID[songKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: song, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

func LoadSong(ctx context.Context, songID string) (*model.Song, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.sLoader.Load(ctx, dataloader.StringKey(songID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	song := result.(*entity.Song)
	return song.ToGraphQL(), nil
}
