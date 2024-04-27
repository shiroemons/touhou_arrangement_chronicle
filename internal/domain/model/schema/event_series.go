package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type EventSeries struct {
	bun.BaseModel `bun:"table:event_series,alias:es"`

	ID          string     `bun:",pk,default:cuid()"`
	Name        string     `bun:"name,nullzero,notnull,unique"`
	DisplayName string     `bun:"display_name,nullzero,notnull"`
	Slug        string     `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	PublishedAt *time.Time `bun:"published_at"`
	ArchivedAt  *time.Time `bun:"archived_at"`
	CreatedAt   time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
	Events      []*Event   `bun:"rel:has-many,join:id=event_series_id"`
}
