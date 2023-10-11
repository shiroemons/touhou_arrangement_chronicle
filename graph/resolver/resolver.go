package resolver

//go:generate go run github.com/99designs/gqlgen generate
import (
	service2 "github.com/shiroemons/touhou_arrangement_chronicle/internal/app/service"
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/generated"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Params struct {
	fx.In

	Logger          *zap.Logger
	ProductSrv      *service2.ProductService
	OriginalSongSrv *service2.OriginalSongService
	EventSeriesSrv  *service2.EventSeriesService
	EventSrv        *service2.EventService
	SubEventSrv     *service2.SubEventService
	CircleSrv       *service2.CircleService
	ArtistSrv       *service2.ArtistService
	TagSrv          *service2.TagService
	GenreSrv        *service2.GenreService
	AlbumSrv        *service2.AlbumService
	SongSrv         *service2.SongService
}

type Resolver struct {
	logger          *zap.Logger
	productSrv      *service2.ProductService
	originalSongSrv *service2.OriginalSongService
	eventSeriesSrv  *service2.EventSeriesService
	eventSrv        *service2.EventService
	subEventSrv     *service2.SubEventService
	circleSrv       *service2.CircleService
	artistSrv       *service2.ArtistService
	tagSrv          *service2.TagService
	genreSrv        *service2.GenreService
	albumSrv        *service2.AlbumService
	songSrv         *service2.SongService
}

// NewResolver Resolver Constructor
func NewResolver(p Params) *Resolver {
	return &Resolver{
		logger:          p.Logger,
		productSrv:      p.ProductSrv,
		originalSongSrv: p.OriginalSongSrv,
		eventSeriesSrv:  p.EventSeriesSrv,
		eventSrv:        p.EventSrv,
		subEventSrv:     p.SubEventSrv,
		circleSrv:       p.CircleSrv,
		artistSrv:       p.ArtistSrv,
		tagSrv:          p.TagSrv,
		genreSrv:        p.GenreSrv,
		albumSrv:        p.AlbumSrv,
		songSrv:         p.SongSrv,
	}
}

// Provider Fx Provider
func Provider(p Params) generated.Config {
	return generated.Config{
		Resolvers: NewResolver(p),
	}
}

var Module = fx.Provide(
	Provider,
)
