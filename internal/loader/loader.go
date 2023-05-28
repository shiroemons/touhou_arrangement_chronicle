package loader

import (
	"github.com/graph-gophers/dataloader"
	"go.uber.org/fx"
)

type Params struct {
	fx.In

	ProductLoader  *ProductLoader
	EventLoader    *EventLoader
	SubEventLoader *SubEventLoader
}

type Loaders struct {
	pLoader  *dataloader.Loader
	eLoader  *dataloader.Loader
	seLoader *dataloader.Loader
}

func LoadersProvider(p Params) *Loaders {
	return &Loaders{
		pLoader:  dataloader.NewBatchedLoader(p.ProductLoader.BatchGetProducts),
		eLoader:  dataloader.NewBatchedLoader(p.EventLoader.BatchGetEvents),
		seLoader: dataloader.NewBatchedLoader(p.SubEventLoader.BatchGetSubEvents),
	}
}
