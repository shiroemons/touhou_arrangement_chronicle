package middleware

import (
	"context"

	"github.com/gin-gonic/gin"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/ctxkey"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/loader"
)

func LoaderMiddleware(db *bun.DB) gin.HandlerFunc {
	// return a middleware that injects the loader to the request context
	return func(c *gin.Context) {
		loaders := loader.LoadersProvider(
			loader.Params{
				AlbumLoader:       loader.AlbumLoaderProvider(db),
				CircleLoader:      loader.CircleLoaderProvider(db),
				EventLoader:       loader.EventLoaderProvider(db),
				EventSeriesLoader: loader.EventSeriesLoaderProvider(db),
				ProductLoader:     loader.ProductLoaderProvider(db),
				SongLoader:        loader.SongLoaderProvider(db),
				SubEventLoader:    loader.SubEventLoaderProvider(db),
			})

		ctx := context.WithValue(c.Request.Context(), ctxkey.LoadersKey, loaders)
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}
