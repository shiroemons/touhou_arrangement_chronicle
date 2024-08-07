package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type Genre struct {
	bun.BaseModel `bun:"table:genres,alias:gen"`

	ID        string    `bun:",pk,default:cuid()"`
	Name      string    `bun:"name,nullzero,notnull,unique"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
