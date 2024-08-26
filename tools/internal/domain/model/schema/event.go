package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type Event struct {
	bun.BaseModel `bun:"table:events,alias:e"`

	ID            string       `bun:",pk,default:cuid()"`
	EventSeriesID string       `bun:"event_series_id,nullzero,notnull"`
	EventSeries   *EventSeries `bun:"rel:belongs-to,join:event_series_id=id"`
	Name          string       `bun:"name,nullzero,notnull,unique"`
	NameReading   string       `bun:"name_reading"`
	DisplayName   string       `bun:"display_name,nullzero,notnull"`
	Slug          string       `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	StartDate     *time.Time   `bun:"start_date"`
	EndDate       *time.Time   `bun:"end_date"`
	EventStatus   string       `bun:"event_status,nullzero,notnull,default:'scheduled'::event_status"`
	Format        string       `bun:"format,nullzero,notnull,default:'offline'::event_format"`
	RegionCode    string       `bun:"region_code,nullzero,notnull,default:'JP'"`
	Address       string       `bun:"address"`
	Description   string       `bun:"description"`
	URL           string       `bun:"url"`
	TwitterURL    string       `bun:"twitter_url"`
	PublishedAt   *time.Time   `bun:"published_at"`
	ArchivedAt    *time.Time   `bun:"archived_at"`
	CreatedAt     time.Time    `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt     time.Time    `bun:"updated_at,notnull,default:current_timestamp"`
	SubEvents     []*SubEvent  `bun:"rel:has-many,join:id=event_id"`
}
