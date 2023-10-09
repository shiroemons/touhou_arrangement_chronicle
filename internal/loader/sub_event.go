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

type SubEventLoader struct {
	seRepo repository2.SubEventRepository
}

func SubEventLoaderProvider(db *bun.DB) *SubEventLoader {
	seRepo := repository.NewSubEventRepository(db)
	return &SubEventLoader{seRepo: seRepo}
}

func (l *SubEventLoader) BatchGetSubEvents(ctx context.Context, keys []string) []*dataloader.Result[*schema.SubEvent] {
	subEventByID, err := l.seRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*schema.SubEvent], len(keys))
	for index, key := range keys {
		subEvent, ok := subEventByID[key]
		if ok {
			output[index] = &dataloader.Result[*schema.SubEvent]{Data: subEvent, Error: nil}
		} else {
			err = fmt.Errorf("subEvent not found %s", key)
			output[index] = &dataloader.Result[*schema.SubEvent]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadSubEvent(ctx context.Context, subEventID string) (*model.SubEvent, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.seLoader.Load(ctx, subEventID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
