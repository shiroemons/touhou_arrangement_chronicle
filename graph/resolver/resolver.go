package resolver

//go:generate go run github.com/99designs/gqlgen generate
import (
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/generated"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/service"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Params struct {
	fx.In

	Logger          *zap.Logger
	ProductSrv      *service.ProductService
	OriginalSongSrv *service.OriginalSongService
	EventSeriesSrv  *service.EventSeriesService
	EventSrv        *service.EventService
	SubEventSrv     *service.SubEventService
	CircleSrv       *service.CircleService
	ArtistSrv       *service.ArtistService
	TagSrv          *service.TagService
}

type Resolver struct {
	logger          *zap.Logger
	productSrv      *service.ProductService
	originalSongSrv *service.OriginalSongService
	eventSeriesSrv  *service.EventSeriesService
	eventSrv        *service.EventService
	subEventSrv     *service.SubEventService
	circleSrv       *service.CircleService
	artistSrv       *service.ArtistService
	tagSrv          *service.TagService
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
