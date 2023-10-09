package schema

import (
	"time"

	"github.com/uptrace/bun"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type OriginalSongDistributionServiceURL struct {
	bun.BaseModel `bun:"table:original_song_distribution_service_urls,alias:osdsu"`

	ID             string    `bun:",pk,default:cuid()"`
	OriginalSongID string    `bun:"original_song_id,nullzero,notnull"`
	Service        string    `bun:"service,nullzero,notnull"`
	URL            string    `bun:"url,nullzero,notnull"`
	CreatedAt      time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt      time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *OriginalSongDistributionServiceURL) ToGraphQL() *model.OriginalSongDistributionServiceURL {
	service, err := model.ToDistributionService(e.Service)
	if err != nil {
		zap.S().Warnf("ToDistributionService error: %s", err)
	}

	return &model.OriginalSongDistributionServiceURL{
		ID:      e.ID,
		Service: service,
		URL:     e.URL,
	}
}
