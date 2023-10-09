package entity

import (
	"time"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/uptrace/bun"
	"go.uber.org/zap"
)

type AlbumDistributionServiceURL struct {
	bun.BaseModel `bun:"table:album_distribution_service_urls,alias:aldsu"`

	ID        string    `bun:",pk,default:cuid()"`
	AlbumID   string    `bun:"album_id,nullzero,notnull"`
	Service   string    `bun:"service,nullzero,notnull"`
	URL       string    `bun:"url,nullzero,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *AlbumDistributionServiceURL) ToGraphQL() *model.AlbumDistributionServiceURL {
	service, err := model.ToDistributionService(e.Service)
	if err != nil {
		zap.S().Warnf("ToDistributionService error: %s", err)
		return nil
	}

	return &model.AlbumDistributionServiceURL{
		ID:      e.ID,
		Service: service,
		URL:     e.URL,
	}
}
