package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type TracksOriginalSongs struct {
	bun.BaseModel `bun:"table:tracks_original_songs,alias:tos"`

	TrackID        string        `bun:"track_id,pk,nullzero,notnull"`
	Track          *Track        `bun:"rel:belongs-to,join:track_id=id"`
	OriginalSongID string        `bun:"original_song_id,pk,nullzero,notnull"`
	OriginalSong   *OriginalSong `bun:"rel:belongs-to,join:original_song_id=id"`
	CreatedAt      time.Time     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time     `bun:"updated_at,notnull,default:current_timestamp"`
}
