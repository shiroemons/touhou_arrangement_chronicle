package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongArrangeCircle struct {
	bun.BaseModel `bun:"table:songs_arrange_circles,alias:sac"`

	SongID    string    `bun:"song_id,pk,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"` // bunのm2mの指定で必要
	CircleID  string    `bun:"circle_id,pk,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"` // bunのm2mの指定で必要
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
