package loader

import (
	"context"

	"github.com/graph-gophers/dataloader"

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

func (l *EventLoader) BatchGetEvents(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	eventIDs := make([]string, len(keys))
	for ix, key := range keys {
		eventIDs[ix] = key.String()
	}

	eventByID, err := l.eRepo.GetMapInIDs(ctx, eventIDs)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, eventKey := range keys {
		event, ok := eventByID[eventKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: event, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

func LoadEvent(ctx context.Context, eventID string) (*model.Event, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.eLoader.Load(ctx, dataloader.StringKey(eventID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	event := result.(*entity.Event)
	return event.ToGraphQL(), nil
}
