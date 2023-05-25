package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/resolver"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/config"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/infra/store"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/loader"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/server"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/service"
)

// inject 関数は、アプリケーションの依存関係を注入します。
func inject() fx.Option {
	return fx.Options(
		fx.Provide(
			// Context
			context.Background,
			// Config
			config.Provider,
			// Logger
			zap.NewProduction,
		),
		// Provide
		store.Module,
		repository.Module,
		server.Module,
		loader.InitModule,
		loader.Module,
		resolver.Module,
		service.Module,

		// Invoke
		server.InvokeModule,
	)
}

func main() {
	// ロガーの新しいインスタンスを初期化します。
	logger, err := zap.NewProduction()
	if err != nil {
		log.Fatalf("can't initialize zap logger: %v", err)
	}
	// プログラムが終了する前に、すべてのログがフラッシュされることを保証します。
	defer func() {
		if err := logger.Sync(); err != nil {
			log.Printf("Error syncing logger: %v", err)
		}
	}()

	// Fxと互換性を持つように、ロガーをfxevent.ZapLoggerでラップします。
	fxLogger := fxevent.ZapLogger{Logger: logger}

	app := fx.New(
		fx.WithLogger(func(log *zap.Logger) fxevent.Logger {
			return &fxLogger
		}),
		inject(), // アプリケーションの依存関係を注入します。
	)

	startCtx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := app.Start(startCtx); err != nil {
		// アプリケーションの起動に失敗した場合、エラーをログに記録します。
		fxLogger.Logger.Fatal("Failed to start the application", zap.Error(err))
	}

	quit := make(chan os.Signal, 1)
	// SIGINT、SIGTERM、Interruptシグナルを受け取るためのチャネルを作成します。
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM, os.Interrupt)
	<-quit
	// サーバーのシャットダウンをログに記録します。
	fxLogger.Logger.Info("Shutting down server...")

	stopCtx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := app.Stop(stopCtx); err != nil {
		// アプリケーションの停止に失敗した場合、エラーをログに記録します。
		fxLogger.Logger.Fatal("Failed to stop the application", zap.Error(err))
	}
}
