package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type Genre struct {
	bun.BaseModel `bun:"table:genres,alias:gen"`

	ID        string    `bun:",pk,default:xid()"`
	Name      string    `bun:"name,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
