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
}

type Resolver struct {
	logger          *zap.Logger
	productSrv      *service.ProductService
	originalSongSrv *service.OriginalSongService
}

// NewResolver Resolver Constructor
func NewResolver(p Params) *Resolver {
	return &Resolver{
		logger:          p.Logger,
		productSrv:      p.ProductSrv,
		originalSongSrv: p.OriginalSongSrv,
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
