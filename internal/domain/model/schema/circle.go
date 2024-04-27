package schema

import (
	"context"
	"time"

	"github.com/uptrace/bun"
)

type Circle struct {
	bun.BaseModel `bun:"table:circles,alias:c"`

	ID                  string     `bun:",pk,default:cuid()"`
	Name                string     `bun:"name,nullzero,notnull"`
	NameReading         string     `bun:"name_reading"`
	Slug                string     `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	InitialLetterType   string     `bun:"initial_letter_type,type:initial_letter_type,nullzero,notnull"`
	InitialLetterDetail string     `bun:"initial_letter_detail,notnull"`
	Description         string     `bun:"description"`
	URL                 string     `bun:"url"`
	BlogURL             string     `bun:"blog_url"`
	TwitterURL          string     `bun:"twitter_url"`
	YoutubeChannelURL   string     `bun:"youtube_channel_url"`
	PublishedAt         *time.Time `bun:"published_at"`
	ArchivedAt          *time.Time `bun:"archived_at"`
	CreatedAt           time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt           time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
	Albums              []*Album   `bun:"m2m:albums_circles,join:Circle=Album"`
	Tags                []*Tag     `bun:"m2m:circles_tags,join:Circle=Tag"`
}

var _ bun.BeforeAppendModelHook = (*Circle)(nil)

func (e *Circle) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.Name != "" {
			ilType, ilDetail, err := InitialLetter(e.Name)
			if err != nil {
				return err
			}
			e.InitialLetterType = string(ilType)
			e.InitialLetterDetail = ilDetail
		}
	case *bun.UpdateQuery:
		if e.Name != "" {
			ilType, ilDetail, err := InitialLetter(e.Name)
			if err != nil {
				return err
			}
			e.InitialLetterType = string(ilType)
			e.InitialLetterDetail = ilDetail
		}
	}
	return nil
}
