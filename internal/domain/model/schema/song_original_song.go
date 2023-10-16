package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongOriginalSong struct {
	bun.BaseModel `bun:"table:songs_original_songs,alias:sos"`

	SongID         string        `bun:"song_id,pk,nullzero,notnull"`
	Song           *Song         `bun:"rel:belongs-to,join:song_id=id"` // bunのm2mの指定で必要
	OriginalSongID string        `bun:"original_song_id,pk,nullzero,notnull"`
	OriginalSong   *OriginalSong `bun:"rel:belongs-to,join:original_song_id=id"` // bunのm2mの指定で必要
	CreatedAt      time.Time     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time     `bun:"updated_at,notnull,default:current_timestamp"`
}
