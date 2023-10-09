package schema

import (
	"context"
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Artist struct {
	bun.BaseModel `bun:"table:artists,alias:a"`

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
	CreatedAt           time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt           time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Artist)(nil)

func (e *Artist) BeforeAppendModel(_ context.Context, query bun.Query) error {
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

func (e *Artist) ToGraphQL() *model.Artist {
	var initialLetterType model.InitialLetterType
	if e.InitialLetterType != "" {
		initialLetterType = model.InitialLetterType(e.InitialLetterType)
	}
	return &model.Artist{
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

type Artists []*Artist

func (arr Artists) ToGraphQLs() []*model.Artist {
	res := make([]*model.Artist, len(arr))
	for i, artist := range arr {
		res[i] = artist.ToGraphQL()
	}
	return res
}
