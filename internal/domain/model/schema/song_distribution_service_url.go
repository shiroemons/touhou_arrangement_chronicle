package schema

import (
	"time"

	"github.com/uptrace/bun"
	"go.uber.org/zap"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
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

// ToGraphQL Convert to GraphQL Schema
func (e *SongDistributionServiceURL) ToGraphQL() *model.SongDistributionServiceURL {
	service, err := model.ToDistributionService(e.Service)
	if err != nil {
		zap.S().Warnf("ToDistributionService error: %s", err)
		return nil
	}

	return &model.SongDistributionServiceURL{
		ID:      e.ID,
		Service: service,
		URL:     e.URL,
	}
}
