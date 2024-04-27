package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongISRC struct {
	bun.BaseModel `bun:"table:song_isrcs,alias:si"`

	ID        string    `bun:",pk,default:cuid()"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	ISRC      string    `bun:"isrc,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
