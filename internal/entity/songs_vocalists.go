package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type SongsVocalists struct {
	bun.BaseModel `bun:"table:songs_vocalists,alias:sv"`

	SongID    string    `bun:"song_id,pk,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"`
	ArtistID  string    `bun:"artist_id,pk,nullzero,notnull"`
	Artist    *Artist   `bun:"rel:belongs-to,join:artist_id=id"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
