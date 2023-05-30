package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventLoader struct {
	eRepo domain.EventRepository
}

func EventLoaderProvider(eRepo domain.EventRepository) *EventLoader {
	return &EventLoader{eRepo: eRepo}
}

func (l *EventLoader) BatchGetEvents(ctx context.Context, keys []string) []*dataloader.Result[*entity.Event] {
	eventByID, err := l.eRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*entity.Event], len(keys))
	for index, key := range keys {
		event, ok := eventByID[key]
		if ok {
			output[index] = &dataloader.Result[*entity.Event]{Data: event, Error: nil}
		} else {
			err = fmt.Errorf("event not found %s", key)
			output[index] = &dataloader.Result[*entity.Event]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadEvent(ctx context.Context, eventID string) (*model.Event, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.eLoader.Load(ctx, eventID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
