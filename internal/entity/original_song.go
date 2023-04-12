package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type OriginalSong struct {
	bun.BaseModel `bun:"table:original_songs,alias:os"`

	ID                                  string                                `bun:",pk"`
	ProductID                           string                                `bun:"product_id,nullzero,notnull"`
	Product                             Product                               `bun:"rel:belongs-to,join:product_id=id"`
	Name                                string                                `bun:"name,nullzero,notnull"`
	Composer                            string                                `bun:"composer,nullzero,notnull,default:''"`
	Arranger                            string                                `bun:"arranger,nullzero,notnull,default:''"`
	TrackNumber                         int                                   `bun:"track_number,nullzero,notnull"`
	Original                            bool                                  `bun:"is_original,notnull"`
	SourceID                            string                                `bun:"source_id,nullzero,notnull,default:''"`
	OriginalSongDistributionServiceURLs []*OriginalSongDistributionServiceURL `bun:"rel:has-many,join:id=original_song_id"`
	Tracks                              []Track                               `bun:"m2m:tracks_original_songs,join:OriginalSong=Track"`
	CreatedAt                           time.Time                             `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                           time.Time                             `bun:"updated_at,notnull,default:current_timestamp"`
}
