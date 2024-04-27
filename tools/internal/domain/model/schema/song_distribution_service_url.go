package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type SongDistributionServiceURL struct {
	bun.BaseModel `bun:"table:song_distribution_service_urls,alias:sdsu"`

	ID        string    `bun:",pk,default:cuid()"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	Service   string    `bun:"service,nullzero,notnull"`
	URL       string    `bun:"url,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
