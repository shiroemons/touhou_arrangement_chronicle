package entity

import (
	"time"

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
	var circles []*model.Circle
	for _, circle := range e.Circles {
		circles = append(circles, circle.ToGraphQL())
	}
	var genres []*model.AlbumGenre
	for _, genre := range e.Genres {
		genres = append(genres, genre.ToGraphQL())
	}
	var tags []*model.AlbumTag
	for _, tag := range e.Tags {
		tags = append(tags, tag.ToGraphQL())
	}

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
	}
	if e.ReleaseDate != nil {
		releaseDate := e.ReleaseDate.Format("2006-01-02")
		album.ReleaseDate = &releaseDate
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
