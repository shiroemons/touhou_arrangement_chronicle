package schema

import (
	"context"
	"time"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/uptrace/bun"
)

type Circle struct {
	bun.BaseModel `bun:"table:circles,alias:c"`

	ID                  string    `bun:",pk,default:cuid()"`
	Name                string    `bun:"name,nullzero,notnull"`
	NameReading         string    `bun:"name_reading,nullzero,notnull,default:''"`
	Slug                string    `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	InitialLetterType   string    `bun:"initial_letter_type,type:initial_letter_type,nullzero,notnull"`
	InitialLetterDetail string    `bun:"initial_letter_detail,notnull"`
	Description         string    `bun:"description,nullzero,notnull,default:''"`
	URL                 string    `bun:"url,nullzero,notnull,default:''"`
	BlogURL             string    `bun:"blog_url,nullzero,notnull,default:''"`
	TwitterURL          string    `bun:"twitter_url,nullzero,notnull,default:''"`
	YoutubeChannelURL   string    `bun:"youtube_channel_url,nullzero,notnull,default:''"`
	Albums              []*Album  `bun:"m2m:albums_circles,join:Circle=Album"`
	Tags                []*Tag    `bun:"m2m:circles_tags,join:Circle=Tag"`
	CreatedAt           time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt           time.Time `bun:"updated_at,notnull,default:current_timestamp"`
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

func (e *Circle) ToGraphQL() *model.Circle {
	var initialLetterType model.InitialLetterType
	if e.InitialLetterType != "" {
		initialLetterType = model.InitialLetterType(e.InitialLetterType)
	}

	return &model.Circle{
		ID:                  e.ID,
		Name:                e.Name,
		NameReading:         e.NameReading,
		Slug:                e.Slug,
		InitialLetterType:   initialLetterType,
		InitialLetterDetail: e.InitialLetterDetail,
		Description:         e.Description,
		URL:                 e.URL,
		BlogURL:             e.BlogURL,
		TwitterURL:          e.TwitterURL,
		YoutubeChannelURL:   e.YoutubeChannelURL,
	}
}

type Circles []*Circle

func (arr Circles) ToGraphQLs() []*model.Circle {
	res := make([]*model.Circle, len(arr))
	for i, circle := range arr {
		res[i] = circle.ToGraphQL()
	}
	return res
}