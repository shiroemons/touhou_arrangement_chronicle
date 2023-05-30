package loader

import (
	"context"
	"fmt"

	"github.com/graph-gophers/dataloader/v7"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductLoader struct {
	pRepo domain.ProductRepository
}

func ProductLoaderProvider(pRepo domain.ProductRepository) *ProductLoader {
	return &ProductLoader{pRepo: pRepo}
}

func (l *ProductLoader) BatchGetProducts(ctx context.Context, keys []string) []*dataloader.Result[*entity.Product] {
	productByID, err := l.pRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*entity.Product], len(keys))
	for index, key := range keys {
		product, ok := productByID[key]
		if ok {
			output[index] = &dataloader.Result[*entity.Product]{Data: product, Error: nil}
		} else {
			err = fmt.Errorf("product not found %s", key)
			output[index] = &dataloader.Result[*entity.Product]{Data: nil, Error: err}
		}
	}
	return output
}

func LoadProduct(ctx context.Context, productID string) (*model.Product, error) {
	loaders := GetLoaders(ctx)
	thunk := loaders.pLoader.Load(ctx, productID)
	result, err := thunk()
	if err != nil {
		return nil, err
	}
	return result.ToGraphQL(), nil
}
