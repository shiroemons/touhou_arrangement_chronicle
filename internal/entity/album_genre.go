package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type AlbumGenre struct {
	bun.BaseModel `bun:"table:albums_genres,alias:alg"`

	ID        string    `bun:",pk,default:xid()"`
	AlbumID   string    `bun:"album_id,nullzero,notnull"`
	Album     *Album    `bun:"rel:belongs-to,join:album_id=id"`
	GenreID   string    `bun:"genre_id,nullzero,notnull"`
	Genre     *Genre    `bun:"rel:belongs-to,join:genre_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
