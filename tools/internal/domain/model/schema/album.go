package schema

import (
	"time"

	"github.com/shopspring/decimal"
	"github.com/uptrace/bun"
)

type Album struct {
	bun.BaseModel `bun:"table:albums,alias:al"`

	ID                           string                         `bun:",pk,default:cuid()"`
	Name                         string                         `bun:"name,nullzero,notnull"`
	NameReading                  string                         `bun:"name_reading"`
	Slug                         string                         `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	ReleaseCircleName            string                         `bun:"release_circle_name"`
	ReleaseDate                  *time.Time                     `bun:"release_date"`
	EventID                      string                         `bun:"event_id"`
	Event                        *Event                         `bun:"rel:belongs-to,join:event_id=id"`
	SubEventID                   string                         `bun:"sub_event_id"`
	SubEvent                     *SubEvent                      `bun:"rel:belongs-to,join:sub_event_id=id"`
	AlbumNumber                  string                         `bun:"album_number"`
	EventPrice                   decimal.NullDecimal            `bun:"event_price"`
	Currency                     string                         `bun:"currency,nullzero,notnull,default:'JPY'"`
	Credit                       string                         `bun:"credit"`
	Introduction                 string                         `bun:"introduction"`
	URL                          string                         `bun:"url"`
	PublishedAt                  *time.Time                     `bun:"published_at"`
	ArchivedAt                   *time.Time                     `bun:"archived_at"`
	CreatedAt                    time.Time                      `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                    time.Time                      `bun:"updated_at,notnull,default:current_timestamp"`
	AlbumConsignmentShops        []*AlbumConsignmentShop        `bun:"rel:has-many,join:id=album_id"`
	AlbumDistributionServiceURLs []*AlbumDistributionServiceURL `bun:"rel:has-many,join:id=album_id"`
	AlbumUPCs                    []*AlbumUPC                    `bun:"rel:has-many,join:id=album_id"`
	Songs                        []*Song                        `bun:"rel:has-many,join:id=album_id"`
	Genres                       []*AlbumGenre                  `bun:"rel:has-many,join:id=album_id"`
	Tags                         []*AlbumTag                    `bun:"rel:has-many,join:id=album_id"`
	Circles                      []*Circle                      `bun:"m2m:albums_circles,join:Album=Circle"`
}
