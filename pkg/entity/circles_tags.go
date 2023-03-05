package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type CirclesTags struct {
	bun.BaseModel `bun:"table:circles_tags,alias:ct"`

	CircleID  string    `bun:"circle_id,pk,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"`
	TagID     string    `bun:"tag_id,pk,nullzero,notnull"`
	Tag       *Tag      `bun:"rel:belongs-to,join:tag_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
