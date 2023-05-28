package loader

import (
	"context"

	"github.com/graph-gophers/dataloader"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SubEventLoader struct {
	seRepo domain.SubEventRepository
}

func SubEventLoaderProvider(seRepo domain.SubEventRepository) *SubEventLoader {
	return &SubEventLoader{seRepo: seRepo}
}

func (l *SubEventLoader) BatchGetSubEvents(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	subEventIDs := make([]string, len(keys))
	for ix, key := range keys {
		subEventIDs[ix] = key.String()
	}

	subEventByID, err := l.seRepo.GetMapInIDs(ctx, subEventIDs)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, subEventKey := range keys {
		subEvent, ok := subEventByID[subEventKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: subEvent, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

func LoadSubEvent(ctx context.Context, subEventID string) (*model.SubEvent, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.seLoader.Load(ctx, dataloader.StringKey(subEventID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	subEvent := result.(*entity.SubEvent)
	return subEvent.ToGraphQL(), nil
}
