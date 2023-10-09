package server

import (
	"context"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	gindump "github.com/tpkeeper/gin-dump"
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/config"
)

const (
	graphqlPath = "/graphql"
	entry       = "/"
)

// AppProvider Fx Provider
func AppProvider(lifecycle fx.Lifecycle, cfg config.Config) *gin.Engine {
	gin.SetMode(gin.ReleaseMode)
	app := gin.New()

	// To Gracefully setup and shuts down http server
	srv := &http.Server{
		Addr:    ":" + cfg.Port,
		Handler: app,
	}

	// Using Fx Lifecycle create start and stop functions to be invoke at appropriate condition
	lifecycle.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			go (func() {
				_ = srv.ListenAndServe()
			})()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			return srv.Shutdown(ctx)
		},
	})

	return app
}

// InvokeMiddleware Fx Invoke Middleware
func InvokeMiddleware(app *gin.Engine, handlers *AppHandlers) {
	for _, mw := range handlers.Middlewares {
		app.Use(mw)
	}
}

// InvokeHandler Fx Invoke Handler
func InvokeHandler(app *gin.Engine, handlers *AppHandlers) {
	app.POST(graphqlPath, gindump.DumpWithOptions(true, true, true, true, false, func(dumpStr string) {
		zap.S().Debugw("request/response dump", "dumpStr", dumpStr)
	}), handlers.GQLHandler)

	env := os.Getenv("ENV")
	if env != "production" {
		app.GET(entry, handlers.Playground)
	}
}
