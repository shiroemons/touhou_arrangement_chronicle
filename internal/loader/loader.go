package loader

import (
	"github.com/graph-gophers/dataloader"
	"go.uber.org/fx"
)

type Params struct {
	fx.In

	ProductLoader     *ProductLoader
	EventSeriesLoader *EventSeriesLoader
	EventLoader       *EventLoader
	SubEventLoader    *SubEventLoader
	AlbumLoader       *AlbumLoader
	SongLoader        *SongLoader
	CircleLoader      *CircleLoader
}

type Loaders struct {
	pLoader  *dataloader.Loader
	esLoader *dataloader.Loader
	eLoader  *dataloader.Loader
	seLoader *dataloader.Loader
	aLoader  *dataloader.Loader
	sLoader  *dataloader.Loader
	cLoader  *dataloader.Loader
}

func LoadersProvider(p Params) *Loaders {
	return &Loaders{
		pLoader:  dataloader.NewBatchedLoader(p.ProductLoader.BatchGetProducts),
		esLoader: dataloader.NewBatchedLoader(p.EventSeriesLoader.BatchGetEventSeries),
		eLoader:  dataloader.NewBatchedLoader(p.EventLoader.BatchGetEvents),
		seLoader: dataloader.NewBatchedLoader(p.SubEventLoader.BatchGetSubEvents),
		aLoader:  dataloader.NewBatchedLoader(p.AlbumLoader.BatchGetAlbums),
		sLoader:  dataloader.NewBatchedLoader(p.SongLoader.BatchGetSongs),
		cLoader:  dataloader.NewBatchedLoader(p.CircleLoader.BatchGetCircles),
	}
}
