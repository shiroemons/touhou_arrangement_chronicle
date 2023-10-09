package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/repository"
)

type EventSeriesLoader struct {
	esRepo domain.EventSeriesRepository
}

func EventSeriesLoaderProvider(db *bun.DB) *EventSeriesLoader {
	esRepo := repository.NewEventSeriesRepository(db)
	return &EventSeriesLoader{esRepo: esRepo}
}

func (l *EventSeriesLoader) BatchGetEventSeries(ctx context.Context, keys []string) []*dataloader.Result[*entity.EventSeries] {
	eventSeriesByID, err := l.esRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*entity.EventSeries], len(keys))
	for index, key := range keys {
		eventSeries, ok := eventSeriesByID[key]
		if ok {
			output[index] = &dataloader.Result[*entity.EventSeries]{Data: eventSeries, Error: nil}
		} else {
			err = fmt.Errorf("eventSeries not found %s", key)
			output[index] = &dataloader.Result[*entity.EventSeries]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadEventSeries(ctx context.Context, eventSeriesID string) (*model.EventSeries, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.esLoader.Load(ctx, eventSeriesID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
