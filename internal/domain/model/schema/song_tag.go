package schema

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type SongTag struct {
	bun.BaseModel `bun:"table:songs_tags,alias:st"`

	ID        string     `bun:",pk,default:cuid()"`
	SongID    string     `bun:"song_id,nullzero,notnull"`
	Song      *Song      `bun:"rel:belongs-to,join:song_id=id"` // bunのm2mの指定で必要
	TagID     string     `bun:"tag_id,nullzero,notnull"`
	Tag       *Tag       `bun:"rel:belongs-to,join:tag_id=id"` // bunのm2mの指定で必要
	LockedAt  *time.Time `bun:"locked_at"`
	CreatedAt time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *SongTag) ToGraphQL() *model.SongTag {
	var locked bool
	if e.LockedAt != nil {
		locked = true
	}

	return &model.SongTag{
		ID:      e.ID,
		Name:    e.Tag.Name,
		TagType: model.TagType(e.Tag.TagType),
		Locked:  locked,
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
