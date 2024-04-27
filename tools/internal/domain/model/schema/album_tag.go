package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type AlbumTag struct {
	bun.BaseModel `bun:"table:albums_tags,alias:alt"`

	ID        string     `bun:",pk,default:cuid()"`
	AlbumID   string     `bun:"album_id,nullzero,notnull"`
	Album     *Album     `bun:"rel:belongs-to,join:album_id=id"` // bunのm2mの指定で必要
	TagID     string     `bun:"tag_id,nullzero,notnull"`
	Tag       *Tag       `bun:"rel:belongs-to,join:tag_id=id"` // bunのm2mの指定で必要
	LockedAt  *time.Time `bun:"locked_at"`
	CreatedAt time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
}
