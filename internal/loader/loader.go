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
	AlbumLoader    *AlbumLoader
	SongLoader     *SongLoader
}

type Loaders struct {
	pLoader  *dataloader.Loader
	eLoader  *dataloader.Loader
	seLoader *dataloader.Loader
	aLoader  *dataloader.Loader
	sLoader  *dataloader.Loader
}

func LoadersProvider(p Params) *Loaders {
	return &Loaders{
		pLoader:  dataloader.NewBatchedLoader(p.ProductLoader.BatchGetProducts),
		eLoader:  dataloader.NewBatchedLoader(p.EventLoader.BatchGetEvents),
		seLoader: dataloader.NewBatchedLoader(p.SubEventLoader.BatchGetSubEvents),
		aLoader:  dataloader.NewBatchedLoader(p.AlbumLoader.BatchGetAlbums),
		sLoader:  dataloader.NewBatchedLoader(p.SongLoader.BatchGetSongs),
	}
}
