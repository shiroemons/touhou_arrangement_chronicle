package store

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/stdlib"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/extra/bundebug"

	"github.com/shiroemons/touhou_arrangement_chronicle/config"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

func NewDB(connString string) *bun.DB {
	pgConfig, err := pgx.ParseConfig(connString)
	if err != nil {
		log.Fatal("postgres provider error", err)
	}
	conn := bun.NewDB(stdlib.OpenDB(*pgConfig), pgdialect.New())

	conn.AddQueryHook(bundebug.NewQueryHook(
		// disable the hook
		bundebug.WithEnabled(false),

		// BUNDEBUG=1 logs failed queries
		// BUNDEBUG=2 logs all queries
		bundebug.FromEnv("BUNDEBUG"),

		// bundebug.WithWriter(&zapio.Writer{Log: logger}),
	))
	// Add Models
	AddRegisterModels(conn)

	var v string
	if err = conn.NewSelect().ColumnExpr("version()").Scan(context.Background(), &v); err != nil {
		log.Fatal(err)
	}
	log.Println(v)

	return conn
}

func PostgresProvider(cfg config.Config) *bun.DB {
	return NewDB(cfg.ConnectURL)
}

func AddRegisterModels(db *bun.DB) {
	db.RegisterModel((*schema.AlbumCircle)(nil))
	db.RegisterModel((*schema.AlbumGenre)(nil))
	db.RegisterModel((*schema.AlbumTag)(nil))
	db.RegisterModel((*schema.CircleGenre)(nil))
	db.RegisterModel((*schema.CircleTag)(nil))
	db.RegisterModel((*schema.SongOriginalSong)(nil))
	db.RegisterModel((*schema.SongArrangeCircle)(nil))
	db.RegisterModel((*schema.SongArranger)(nil))
	db.RegisterModel((*schema.SongComposer)(nil))
	db.RegisterModel((*schema.SongLyricist)(nil))
	db.RegisterModel((*schema.SongRearranger)(nil))
	db.RegisterModel((*schema.SongVocalist)(nil))
	db.RegisterModel((*schema.SongGenre)(nil))
	db.RegisterModel((*schema.SongTag)(nil))
}
