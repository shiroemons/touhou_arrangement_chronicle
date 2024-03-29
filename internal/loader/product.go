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

type ProductLoader struct {
	pRepo repository2.ProductRepository
}

func ProductLoaderProvider(db *bun.DB) *ProductLoader {
	pRepo := repository.NewProductRepository(db)
	return &ProductLoader{pRepo: pRepo}
}

func (l *ProductLoader) BatchGetProducts(ctx context.Context, keys []string) []*dataloader.Result[*schema.Product] {
	productByID, err := l.pRepo.GetMapInIDs(ctx, keys)
	if err != nil {
		return nil
	}

	output := make([]*dataloader.Result[*schema.Product], len(keys))
	for index, key := range keys {
		product, ok := productByID[key]
		if ok {
			output[index] = &dataloader.Result[*schema.Product]{Data: product, Error: nil}
		} else {
			err = fmt.Errorf("product not found %s", key)
			output[index] = &dataloader.Result[*schema.Product]{Data: nil, Error: err}
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
