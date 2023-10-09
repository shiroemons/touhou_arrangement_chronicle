package server

import (
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/gin-contrib/cors"
	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"github.com/uptrace/bun"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/generated"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/config"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/infrastructure/middleware"
)

// AppHandlers / Controller
type AppHandlers struct {
	Middlewares []gin.HandlerFunc
	GQLHandler  gin.HandlerFunc
	Playground  gin.HandlerFunc
}

// AppHandlersProvider Fx Provider
func AppHandlersProvider(module generated.Config, logger *zap.Logger, cfg config.Config, db *bun.DB) *AppHandlers {
	return &AppHandlers{
		Middlewares: []gin.HandlerFunc{
			middleware.LoaderMiddleware(db),
			ginzap.GinzapWithConfig(logger, customGinzapConfig()),
			ginzap.RecoveryWithZap(logger, true),
			cors.New(customCorsConfig(cfg)),
		},
		GQLHandler: GraphqlHandler(module),
		Playground: PlaygroundHandler(),
	}
}

// GraphqlHandler GraphQL Query Handler
func GraphqlHandler(module generated.Config) gin.HandlerFunc {
	graphqlServer := handler.NewDefaultServer(generated.NewExecutableSchema(module))
	return func(ctx *gin.Context) {
		graphqlServer.ServeHTTP(ctx.Writer, ctx.Request)
	}
}

// PlaygroundHandler Playground Handler
func PlaygroundHandler() gin.HandlerFunc {
	playgroundHandler := playground.Handler("Nodes-Graph API Playground", graphqlPath)
	return func(ctx *gin.Context) {
		playgroundHandler.ServeHTTP(ctx.Writer, ctx.Request)
	}
}
