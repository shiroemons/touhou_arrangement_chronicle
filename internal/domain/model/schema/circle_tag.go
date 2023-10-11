package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type CircleTag struct {
	bun.BaseModel `bun:"table:circles_tags,alias:ct"`

	ID        string    `bun:",pk,default:cuid()"`
	CircleID  string    `bun:"circle_id,nullzero,notnull"`
	TagID     string    `bun:"tag_id,nullzero,notnull"`
	Locked    bool      `bun:"locked,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
