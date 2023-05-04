package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type Tag struct {
	bun.BaseModel `bun:"table:tags,alias:tag"`

	ID        string    `bun:",pk,default:xid()"`
	Name      string    `bun:"name,nullzero,notnull,unique"`
	TagType   string    `bun:"tag_type,nullzero,notnull,default:'unknown'::tag_type"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
