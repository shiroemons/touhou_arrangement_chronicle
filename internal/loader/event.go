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

type EventLoader struct {
	eRepo repository2.EventRepository
}

func EventLoaderProvider(db *bun.DB) *EventLoader {
	eRepo := repository.NewEventRepository(db)
	return &EventLoader{eRepo: eRepo}
}

func (l *EventLoader) BatchGetEvents(ctx context.Context, keys []string) []*dataloader.Result[*schema.Event] {
	eventByID, err := l.eRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*schema.Event], len(keys))
	for index, key := range keys {
		event, ok := eventByID[key]
		if ok {
			output[index] = &dataloader.Result[*schema.Event]{Data: event, Error: nil}
		} else {
			err = fmt.Errorf("event not found %s", key)
			output[index] = &dataloader.Result[*schema.Event]{Data: nil, Error: err}
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
