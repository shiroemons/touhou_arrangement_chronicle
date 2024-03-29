package schema

import (
	"time"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
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

// ToGraphQL Convert to GraphQL Schema
func (e *AlbumTag) ToGraphQL() *model.AlbumTag {
	var locked bool
	if e.LockedAt != nil {
		locked = true
	}

	return &model.AlbumTag{
		ID:      e.ID,
		Name:    e.Tag.Name,
		TagType: model.TagType(e.Tag.TagType),
		Locked:  locked,
	}
}

// AlbumTags is a slice of AlbumTag
type AlbumTags []*AlbumTag

// ToGraphQLs Convert to GraphQL Schema
func (arr AlbumTags) ToGraphQLs() []*model.AlbumTag {
	res := make([]*model.AlbumTag, 0, len(arr))
	for _, albumTag := range arr {
		res = append(res, albumTag.ToGraphQL())
	}
	return res
}
