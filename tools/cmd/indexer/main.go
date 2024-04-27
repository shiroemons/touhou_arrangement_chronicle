package main

import (
	"context"
	"os"

	"github.com/meilisearch/meilisearch-go"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/infrastructure/store"
)

func main() {
	run()
}

func initDB() *bun.DB {
	return store.NewDB(os.Getenv("CONNECT_URL"))
}

func initMeilisearch() *meilisearch.Client {
	return meilisearch.NewClient(meilisearch.ClientConfig{
		Host:   os.Getenv("MEILISEARCH_HOST"),
		APIKey: os.Getenv("MEILISEARCH_API_KEY"),
	})
}

func run() {
	ctx := context.Background()
	db := initDB()
	cli := initMeilisearch()
	setupOriginalSongs(ctx, db, cli)
	setupAlbums(ctx, db, cli)
	setupSongs(ctx, db, cli)
	setup(cli)
}
