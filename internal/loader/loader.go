package loader

import (
	"context"

	"github.com/graph-gophers/dataloader/v7"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"go.uber.org/fx"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/ctxkey"
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
	pLoader  *dataloader.Loader[string, *schema.Product]
	esLoader *dataloader.Loader[string, *schema.EventSeries]
	eLoader  *dataloader.Loader[string, *schema.Event]
	seLoader *dataloader.Loader[string, *schema.SubEvent]
	aLoader  *dataloader.Loader[string, *schema.Album]
	sLoader  *dataloader.Loader[string, *schema.Song]
	cLoader  *dataloader.Loader[string, *schema.Circle]
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

func GetLoaders(ctx context.Context) *Loaders {
	return ctx.Value(ctxkey.LoadersKey).(*Loaders)
}
