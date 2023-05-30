package loader

import (
	"github.com/graph-gophers/dataloader/v7"
	"go.uber.org/fx"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
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
	pLoader  *dataloader.Loader[string, *entity.Product]
	esLoader *dataloader.Loader[string, *entity.EventSeries]
	eLoader  *dataloader.Loader[string, *entity.Event]
	seLoader *dataloader.Loader[string, *entity.SubEvent]
	aLoader  *dataloader.Loader[string, *entity.Album]
	sLoader  *dataloader.Loader[string, *entity.Song]
	cLoader  *dataloader.Loader[string, *entity.Circle]
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
