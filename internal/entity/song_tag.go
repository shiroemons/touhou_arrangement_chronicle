package entity

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type SongTag struct {
	bun.BaseModel `bun:"table:songs_tags,alias:st"`

	ID        string    `bun:",pk,default:cuid()"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"`
	TagID     string    `bun:"tag_id,nullzero,notnull"`
	Tag       *Tag      `bun:"rel:belongs-to,join:tag_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *SongTag) ToGraphQL() *model.SongTag {
	return &model.SongTag{
		ID:      e.ID,
		Name:    e.Tag.Name,
		TagType: model.TagType(e.Tag.TagType),
		Locked:  e.Locked,
	}
}

// SongTags is a slice of SongTag
type SongTags []*SongTag

// ToGraphQLs Convert to GraphQL Schema
func (arr SongTags) ToGraphQLs() []*model.SongTag {
	res := make([]*model.SongTag, 0, len(arr))
	for _, v := range arr {
		res = append(res, v.ToGraphQL())
	}
	return res
}
