package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type CircleGenre struct {
	bun.BaseModel `bun:"table:circles_genres,alias:cg"`

	ID        string    `bun:",pk,default:cuid()"`
	CircleID  string    `bun:"circle_id,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"`
	GenreID   string    `bun:"genre_id,nullzero,notnull"`
	Genre     *Genre    `bun:"rel:belongs-to,join:genre_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
