package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongTag struct {
	bun.BaseModel `bun:"table:songs_tags,alias:st"`

	ID        string     `bun:",pk,default:cuid()"`
	SongID    string     `bun:"song_id,nullzero,notnull"`
	Song      *Song      `bun:"rel:belongs-to,join:song_id=id"` // bunのm2mの指定で必要
	TagID     string     `bun:"tag_id,nullzero,notnull"`
	Tag       *Tag       `bun:"rel:belongs-to,join:tag_id=id"` // bunのm2mの指定で必要
	LockedAt  *time.Time `bun:"locked_at"`
	CreatedAt time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
}
