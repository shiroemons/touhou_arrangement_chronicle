package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type SongsOriginalSongs struct {
	bun.BaseModel `bun:"table:songs_original_songs,alias:sos"`

	SongID         string        `bun:"song_id,pk,nullzero,notnull"`
	Song           *Song         `bun:"rel:belongs-to,join:song_id=id"`
	OriginalSongID string        `bun:"original_song_id,pk,nullzero,notnull"`
	OriginalSong   *OriginalSong `bun:"rel:belongs-to,join:original_song_id=id"`
	CreatedAt      time.Time     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time     `bun:"updated_at,notnull,default:current_timestamp"`
}
