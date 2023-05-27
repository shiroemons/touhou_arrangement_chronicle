package entity

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Genre struct {
	bun.BaseModel `bun:"table:genres,alias:gen"`

	ID        string    `bun:",pk,default:xid()"`
	Name      string    `bun:"name,nullzero,notnull,unique"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *Genre) ToGraphQL() *model.Genre {
	return &model.Genre{
		ID:   e.ID,
		Name: e.Name,
	}
}

type Genres []*Genre

func (arr Genres) ToGraphQLs() []*model.Genre {
	res := make([]*model.Genre, 0, len(arr))
	for _, genre := range arr {
		res = append(res, genre.ToGraphQL())
	}
	return res
}
