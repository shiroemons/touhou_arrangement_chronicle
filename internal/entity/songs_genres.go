package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type SongsGenres struct {
	bun.BaseModel `bun:"table:songs_genres,alias:sg"`

	SongID    string    `bun:"song_id,pk,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"`
	TagID     string    `bun:"tag_id,pk,nullzero,notnull"`
	GenreTag  *Tag      `bun:"rel:belongs-to,join:tag_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
