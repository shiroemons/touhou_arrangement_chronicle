package schema

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Tag struct {
	bun.BaseModel `bun:"table:tags,alias:tag"`

	ID        string    `bun:",pk,default:cuid()"`
	Name      string    `bun:"name,nullzero,notnull,unique"`
	TagType   string    `bun:"tag_type,nullzero,notnull,default:'unknown'::tag_type"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *Tag) ToGraphQL() *model.Tag {
	return &model.Tag{
		ID:      e.ID,
		Name:    e.Name,
		TagType: model.TagType(e.TagType),
	}
}

type Tags []*Tag

func (arr Tags) ToGraphQLs() []*model.Tag {
	var res []*model.Tag
	for _, tag := range arr {
		res = append(res, tag.ToGraphQL())
	}
	return res
}
