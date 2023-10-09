package loader

import (
	"context"

	"github.com/gin-gonic/gin"
	"github.com/uptrace/bun"
)

type ctxKey string

const (
	loadersKey = ctxKey("dataloaders")
)

func Middleware(db *bun.DB) gin.HandlerFunc {
	// return a middleware that injects the loader to the request context
	return func(c *gin.Context) {
		loaders := LoadersProvider(
			Params{
				AlbumLoader:       AlbumLoaderProvider(db),
				CircleLoader:      CircleLoaderProvider(db),
				EventLoader:       EventLoaderProvider(db),
				EventSeriesLoader: EventSeriesLoaderProvider(db),
				ProductLoader:     ProductLoaderProvider(db),
				SongLoader:        SongLoaderProvider(db),
				SubEventLoader:    SubEventLoaderProvider(db),
			})

		ctx := context.WithValue(c.Request.Context(), loadersKey, loaders)
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}

func GetLoaders(ctx context.Context) *Loaders {
	return ctx.Value(loadersKey).(*Loaders)
}
