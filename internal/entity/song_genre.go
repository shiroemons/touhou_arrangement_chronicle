package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type SongGenre struct {
	bun.BaseModel `bun:"table:songs_genres,alias:sg"`

	ID        string    `bun:",pk,default:xid()"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"`
	GenreID   string    `bun:"genre_id,nullzero,notnull"`
	Genre     *Genre    `bun:"rel:belongs-to,join:genre_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
