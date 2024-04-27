package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type OriginalSong struct {
	bun.BaseModel `bun:"table:original_songs,alias:os"`

	ID                                  string                                `bun:",pk"`
	ProductID                           string                                `bun:"product_id,nullzero,notnull"`
	Product                             *Product                              `bun:"rel:belongs-to,join:product_id=id"`
	Name                                string                                `bun:"name,nullzero,notnull"`
	Composer                            string                                `bun:"composer"`
	Arranger                            string                                `bun:"arranger"`
	TrackNumber                         int                                   `bun:"track_number,nullzero,notnull"`
	Original                            bool                                  `bun:"is_original,notnull"`
	SourceID                            string                                `bun:"source_id"`
	OriginalSongDistributionServiceURLs []*OriginalSongDistributionServiceURL `bun:"rel:has-many,join:id=original_song_id"`
	Songs                               []*Song                               `bun:"m2m:songs_original_songs,join:OriginalSong=Song"`
	CreatedAt                           time.Time                             `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                           time.Time                             `bun:"updated_at,notnull,default:current_timestamp"`
}
