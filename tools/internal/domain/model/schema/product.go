package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type Product struct {
	bun.BaseModel `bun:"table:products,alias:p"`

	ID                             string                           `bun:",pk"`
	Name                           string                           `bun:"name,nullzero,notnull"`
	NameReading                    string                           `bun:"name_reading"`
	ShortName                      string                           `bun:"short_name,nullzero,notnull"`
	ProductType                    string                           `bun:"product_type,nullzero,notnull"`
	SeriesNumber                   float64                          `bun:"series_number,nullzero,notnull"`
	CreatedAt                      time.Time                        `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                      time.Time                        `bun:"updated_at,notnull,default:current_timestamp"`
	OriginalSongs                  []*OriginalSong                  `bun:"rel:has-many,join:id=product_id"`
	ProductDistributionServiceURLs []*ProductDistributionServiceURL `bun:"rel:has-many,join:id=product_id"`
}
