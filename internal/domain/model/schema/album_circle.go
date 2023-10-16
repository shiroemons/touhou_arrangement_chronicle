package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type AlbumCircle struct {
	bun.BaseModel `bun:"table:albums_circles,alias:alc"`

	AlbumID   string    `bun:"album_id,pk,nullzero,notnull"`
	Album     *Album    `bun:"rel:belongs-to,join:album_id=id"` // bunのm2mの指定で必要
	CircleID  string    `bun:"circle_id,pk,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"` // bunのm2mの指定で必要
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
