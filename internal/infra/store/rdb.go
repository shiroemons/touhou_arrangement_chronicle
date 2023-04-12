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
	db.RegisterModel((*entity.AlbumsCircles)(nil))
	db.RegisterModel((*entity.AlbumsTags)(nil))
	db.RegisterModel((*entity.AlbumsGenres)(nil))
	db.RegisterModel((*entity.CirclesTags)(nil))
	db.RegisterModel((*entity.TracksArrangeCircles)(nil))
	db.RegisterModel((*entity.TracksArrangers)(nil))
	db.RegisterModel((*entity.TracksComposers)(nil))
	db.RegisterModel((*entity.TracksGenres)(nil))
	db.RegisterModel((*entity.TracksLyricists)(nil))
	db.RegisterModel((*entity.TracksOriginalSongs)(nil))
	db.RegisterModel((*entity.TracksRearrangers)(nil))
	db.RegisterModel((*entity.TracksTags)(nil))
	db.RegisterModel((*entity.TracksVocalists)(nil))
}
