package entity

import (
	"time"

	"github.com/samber/lo"
	"github.com/shopspring/decimal"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Album struct {
	bun.BaseModel `bun:"table:albums,alias:al"`

	ID                           string                         `bun:",pk,default:xid()"`
	Name                         string                         `bun:"name,nullzero,notnull"`
	NameReading                  string                         `bun:"name_reading,nullzero,notnull,default:''"`
	Slug                         string                         `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	ReleaseCircleName            string                         `bun:"release_circle_name,nullzero,notnull,default:''"`
	ReleaseDate                  *time.Time                     `bun:"release_date"`
	EventID                      string                         `bun:"event_id,nullzero,notnull,default:''"`
	Event                        *Event                         `bun:"rel:belongs-to,join:event_id=id"`
	SubEventID                   string                         `bun:"sub_event_id,nullzero,notnull,default:''"`
	SubEvent                     *SubEvent                      `bun:"rel:belongs-to,join:sub_event_id=id"`
	SearchEnabled                bool                           `bun:"search_enabled,nullzero,notnull,default:true"`
	AlbumNumber                  string                         `bun:"album_number,nullzero,notnull,default:''"`
	EventPrice                   decimal.NullDecimal            `bun:"event_price"`
	Currency                     string                         `bun:"currency,nullzero,notnull,default:'JPY'"`
	Credit                       string                         `bun:"credit,nullzero,notnull,default:''"`
	Introduction                 string                         `bun:"introduction,nullzero,notnull,default:''"`
	URL                          string                         `bun:"url,nullzero,notnull,default:''"`
	AlbumConsignmentShops        []*AlbumConsignmentShop        `bun:"rel:has-many,join:id=album_id"`
	AlbumDistributionServiceURLs []*AlbumDistributionServiceURL `bun:"rel:has-many,join:id=album_id"`
	AlbumUPCs                    []*AlbumUPC                    `bun:"rel:has-many,join:id=album_id"`
	Songs                        []*Song                        `bun:"rel:has-many,join:id=album_id"`
	Genres                       []*AlbumGenre                  `bun:"rel:has-many,join:id=album_id"`
	Tags                         []*AlbumTag                    `bun:"rel:has-many,join:id=album_id"`
	Circles                      []*Circle                      `bun:"m2m:albums_circles,join:Album=Circle"`
	CreatedAt                    time.Time                      `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                    time.Time                      `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *Album) ToGraphQL() *model.Album {
	circles := ConvertSlice(e.Circles, func(c *Circle) *model.Circle { return c.ToGraphQL() })
	genres := ConvertSlice(e.Genres, func(g *AlbumGenre) *model.AlbumGenre { return g.ToGraphQL() })
	tags := ConvertSlice(e.Tags, func(t *AlbumTag) *model.AlbumTag { return t.ToGraphQL() })
	consignmentShops := ConvertSlice(e.AlbumConsignmentShops, func(a *AlbumConsignmentShop) *model.ConsignmentShop { return a.ToGraphQL() })
	distributionUrls := ConvertSlice(e.AlbumDistributionServiceURLs, func(u *AlbumDistributionServiceURL) *model.AlbumDistributionServiceURL { return u.ToGraphQL() })

	album := &model.Album{
		ID:                e.ID,
		Name:              e.Name,
		NameReading:       e.NameReading,
		Slug:              e.Slug,
		ReleaseCircleName: e.ReleaseCircleName,
		SearchEnabled:     e.SearchEnabled,
		AlbumNumber:       e.AlbumNumber,
		Currency:          e.Currency,
		Credit:            e.Credit,
		Introduction:      e.Introduction,
		URL:               e.URL,
		Circles:           circles,
		Genres:            genres,
		Tags:              tags,
		ConsignmentShops:  consignmentShops,
		DistributionUrls:  distributionUrls,
	}
	if e.ReleaseDate != nil {
		album.ReleaseDate = lo.ToPtr(e.ReleaseDate.Format("2006-01-02"))
	}
	if e.EventID != "" {
		album.Event = &model.Event{ID: e.EventID}
	}
	if e.SubEventID != "" {
		album.SubEvent = &model.SubEvent{ID: e.SubEventID}
	}

	return album
}

type Albums []*Album

func (arr Albums) ToGraphQLs() []*model.Album {
	res := make([]*model.Album, len(arr))
	for i, v := range arr {
		res[i] = v.ToGraphQL()
	}
	return res
}
