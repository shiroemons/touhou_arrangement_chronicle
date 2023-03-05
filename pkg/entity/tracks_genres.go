package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type TracksGenres struct {
	bun.BaseModel `bun:"table:tracks_genres,alias:tg"`

	TrackID   string    `bun:"track_id,pk,nullzero,notnull"`
	Track     *Track    `bun:"rel:belongs-to,join:track_id=id"`
	TagID     string    `bun:"tag_id,pk,nullzero,notnull"`
	GenreTag  *Tag      `bun:"rel:belongs-to,join:tag_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
