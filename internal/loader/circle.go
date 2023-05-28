package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader"
	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
)

type CircleLoader struct {
	cRepo domain.CircleRepository
}

func CircleLoaderProvider(cRepo domain.CircleRepository) *CircleLoader {
	return &CircleLoader{cRepo: cRepo}
}

func (l *CircleLoader) BatchGetCircles(ctx context.Context, keys dataloader.Keys) []*dataloader.Result {
	circleIds := make([]string, len(keys))
	for ix, key := range keys {
		circleIds[ix] = key.String()
	}

	circleByID, err := l.cRepo.GetMapInIDs(ctx, circleIds)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result, len(keys))
	for index, circleKey := range keys {
		circle, ok := circleByID[circleKey.String()]
		if ok {
			output[index] = &dataloader.Result{Data: circle, Error: nil}
		} else {
			output[index] = &dataloader.Result{Data: nil, Error: nil}
		}
	}
	return output
}

func LoadCircle(ctx context.Context, circleID string) (*model.Circle, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.cLoader.Load(ctx, dataloader.StringKey(circleID))
	result, err := thunk()
	if err != nil {
		return nil, fmt.Errorf("error executing thunk: %w", err)
	}

	circle, ok := result.(*entity.Circle)
	if !ok {
		return nil, fmt.Errorf("unable to cast result to *entity.Circle")
	}

	if circle == nil {
		return &model.Circle{}, nil
	}

	return circle.ToGraphQL(), nil
}
