package loader

import (
	"github.com/graph-gophers/dataloader"
	"go.uber.org/fx"
)

type Params struct {
	fx.In

	ProductLoader *ProductLoader
	EventLoader   *EventLoader
}

type Loaders struct {
	pLoader *dataloader.Loader
	eLoader *dataloader.Loader
}

func LoadersProvider(p Params) *Loaders {
	return &Loaders{
		pLoader: dataloader.NewBatchedLoader(p.ProductLoader.BatchGetProducts),
		eLoader: dataloader.NewBatchedLoader(p.EventLoader.BatchGetEvents),
	}
}
