package entity

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type OriginalSong struct {
	bun.BaseModel `bun:"table:original_songs,alias:os"`

	ID                                  string                                `bun:",pk"`
	ProductID                           string                                `bun:"product_id,nullzero,notnull"`
	Product                             *Product                              `bun:"rel:belongs-to,join:product_id=id"`
	Name                                string                                `bun:"name,nullzero,notnull"`
	Composer                            string                                `bun:"composer,nullzero,notnull,default:''"`
	Arranger                            string                                `bun:"arranger,nullzero,notnull,default:''"`
	TrackNumber                         int                                   `bun:"track_number,nullzero,notnull"`
	Original                            bool                                  `bun:"is_original,notnull"`
	SourceID                            string                                `bun:"source_id,nullzero,notnull,default:''"`
	OriginalSongDistributionServiceURLs []*OriginalSongDistributionServiceURL `bun:"rel:has-many,join:id=original_song_id"`
	Songs                               []*Song                               `bun:"m2m:songs_original_songs,join:OriginalSong=Song"`
	CreatedAt                           time.Time                             `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                           time.Time                             `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *OriginalSong) ToGraphQL() *model.OriginalSong {
	// OriginalSongDistributionServiceURLsをmodel.OriginalSongDistributionServiceURLに変換
	var distributionServiceURLs []*model.OriginalSongDistributionServiceURL
	for _, distributionServiceURL := range e.OriginalSongDistributionServiceURLs {
		distributionServiceURLs = append(distributionServiceURLs, distributionServiceURL.ToGraphQL())
	}

	return &model.OriginalSong{
		ID:               e.ID,
		Product:          &model.Product{ID: e.ProductID},
		Name:             e.Name,
		Composer:         e.Composer,
		Arranger:         e.Arranger,
		TrackNumber:      e.TrackNumber,
		IsOriginal:       e.Original,
		SourceID:         e.SourceID,
		DistributionUrls: distributionServiceURLs,
	}
}

// OriginalSongs Method Injection
type OriginalSongs []*OriginalSong

// ToGraphQLs Convert all to GraphQL Schema
func (arr OriginalSongs) ToGraphQLs() []*model.OriginalSong {
	res := make([]*model.OriginalSong, len(arr))
	for i, os := range arr {
		res[i] = os.ToGraphQL()
	}
	return res
}
