package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type Circle struct {
	bun.BaseModel `bun:"table:circles,alias:c"`

	ID                  string    `bun:",pk"`
	Name                string    `bun:"name,nullzero,notnull"`
	NameReading         string    `bun:"name_reading,nullzero,notnull,default:''"`
	InitialLetterType   string    `bun:"initial_letter_type,type:initial_letter_type,nullzero,notnull"`
	InitialLetterDetail string    `bun:"initial_letter_detail,notnull"`
	Description         string    `bun:"description,nullzero,notnull,default:''"`
	URL                 string    `bun:"url,nullzero,notnull,default:''"`
	BlogURL             string    `bun:"blog_url,nullzero,notnull,default:''"`
	TwitterURL          string    `bun:"twitter_url,nullzero,notnull,default:''"`
	YoutubeChannelURL   string    `bun:"youtube_channel_url,nullzero,notnull,default:''"`
	Albums              []Album   `bun:"m2m:albums_circles,join:Circle=Album"`
	Tags                []Tag     `bun:"m2m:circles_tags,join:Circle=Tag"`
	CreatedAt           time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt           time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Circle)(nil)

func (e *Circle) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
