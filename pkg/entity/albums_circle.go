package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type AlbumsCircles struct {
	bun.BaseModel `bun:"table:albums_circles,alias:alc"`

	AlbumID   string    `bun:"album_id,pk,nullzero,notnull"`
	Album     *Album    `bun:"rel:belongs-to,join:album_id=id"`
	CircleID  string    `bun:"circle_id,pk,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
