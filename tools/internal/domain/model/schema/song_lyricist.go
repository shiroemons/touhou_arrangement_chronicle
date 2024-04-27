package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongLyricist struct {
	bun.BaseModel `bun:"table:songs_lyricists,alias:sl"`

	SongID    string    `bun:"song_id,pk,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"` // bunのm2mの指定で必要
	ArtistID  string    `bun:"artist_id,pk,nullzero,notnull"`
	Artist    *Artist   `bun:"rel:belongs-to,join:artist_id=id"` // bunのm2mの指定で必要
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
