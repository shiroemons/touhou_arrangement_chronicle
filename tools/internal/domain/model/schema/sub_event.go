package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SubEvent struct {
	bun.BaseModel `bun:"table:sub_events,alias:se"`

	ID          string     `bun:",pk,default:cuid()"`
	EventID     string     `bun:"event_id,nullzero,notnull"`
	Name        string     `bun:"name,nullzero,notnull"`
	NameReading string     `bun:"name_reading"`
	DisplayName string     `bun:"display_name,nullzero,notnull"`
	Slug        string     `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	EventDate   *time.Time `bun:"event_date,nullzero,notnull"`
	EventStatus string     `bun:"event_status,nullzero,notnull,default:'scheduled'::event_status"`
	Description string     `bun:"description"`
	PublishedAt *time.Time `bun:"published_at"`
	ArchivedAt  *time.Time `bun:"archived_at"`
	CreatedAt   time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
}
