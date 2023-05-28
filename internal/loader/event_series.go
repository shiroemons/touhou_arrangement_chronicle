package loader

import (
	"context"

	"github.com/graph-gophers/dataloader"
	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventSeriesLoader struct {
	esRepo domain.EventSeriesRepository
}

func EventSeriesLoaderProvider(esRepo domain.EventSeriesRepository) *EventSeriesLoader {
	return &EventSeriesLoader{esRepo: esRepo}
}

func (l *EventSeriesLoader) BatchGetEventSeries(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	eventSeriesIDs := make([]string, len(keys))
	for ix, key := range keys {
		eventSeriesIDs[ix] = key.String()
	}

	eventSeriesByID, err := l.esRepo.GetMapInIDs(ctx, eventSeriesIDs)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, eventSeriesKey := range keys {
		eventSeries, ok := eventSeriesByID[eventSeriesKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: eventSeries, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

func LoadEventSeries(ctx context.Context, eventSeriesID string) (*model.EventSeries, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.esLoader.Load(ctx, dataloader.StringKey(eventSeriesID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	eventSeries := result.(*entity.EventSeries)
	return eventSeries.ToGraphQL(), nil
}
