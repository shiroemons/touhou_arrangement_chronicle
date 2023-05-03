package store

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/stdlib"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/pgdialect"
	"github.com/uptrace/bun/extra/bundebug"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
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

func AddRegisterModels(db *bun.DB) {
	db.RegisterModel((*entity.AlbumCircle)(nil))
	db.RegisterModel((*entity.AlbumGenre)(nil))
	db.RegisterModel((*entity.AlbumTag)(nil))
	db.RegisterModel((*entity.CircleGenre)(nil))
	db.RegisterModel((*entity.CircleTag)(nil))
	db.RegisterModel((*entity.SongOriginalSong)(nil))
	db.RegisterModel((*entity.SongArrangeCircle)(nil))
	db.RegisterModel((*entity.SongArranger)(nil))
	db.RegisterModel((*entity.SongComposer)(nil))
	db.RegisterModel((*entity.SongLyricist)(nil))
	db.RegisterModel((*entity.SongRearranger)(nil))
	db.RegisterModel((*entity.SongVocalist)(nil))
	db.RegisterModel((*entity.SongGenre)(nil))
	db.RegisterModel((*entity.SongTag)(nil))
}
