package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"
	repository2 "github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/infrastructure/repository"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleLoader struct {
	cRepo repository2.CircleRepository
}

func CircleLoaderProvider(db *bun.DB) *CircleLoader {
	cRepo := repository.NewCircleRepository(db)
	return &CircleLoader{cRepo: cRepo}
}

func (l *CircleLoader) BatchGetCircles(ctx context.Context, keys []string) []*dataloader.Result[*entity.Circle] {
	circleByID, err := l.cRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*entity.Circle], len(keys))
	for index, key := range keys {
		circle, ok := circleByID[key]
		if ok {
			output[index] = &dataloader.Result[*entity.Circle]{Data: circle, Error: nil}
		} else {
			err = fmt.Errorf("circle not found %s", key)
			output[index] = &dataloader.Result[*entity.Circle]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadCircle(ctx context.Context, circleID string) (*model.Circle, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.cLoader.Load(ctx, circleID)
	result, err := thunk()
	if err != nil {
		return nil, fmt.Errorf("error executing thunk: %w", err)
	}
	return result.ToGraphQL(), nil
}
