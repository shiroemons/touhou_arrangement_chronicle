package entity

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type EventSeries struct {
	bun.BaseModel `bun:"table:event_series,alias:es"`

	ID          string    `bun:",pk,default:cuid()"`
	Name        string    `bun:"name,nullzero,notnull,unique"`
	DisplayName string    `bun:"display_name,nullzero,notnull"`
	Slug        string    `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	Events      []*Event  `bun:"rel:has-many,join:id=event_series_id"`
	CreatedAt   time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *EventSeries) ToGraphQL() *model.EventSeries {
	events := ConvertSlice(e.Events, func(v *Event) *model.Event { return v.ToGraphQL() })

	return &model.EventSeries{
		ID:          e.ID,
		Name:        e.Name,
		DisplayName: e.DisplayName,
		Slug:        e.Slug,
		Events:      events,
	}
}

// EventSeriesArr Method Injection
type EventSeriesArr []*EventSeries

// ToGraphQLs Convert all to GraphQL Schema
func (arr EventSeriesArr) ToGraphQLs() []*model.EventSeries {
	res := make([]*model.EventSeries, len(arr))
	for i, es := range arr {
		res[i] = es.ToGraphQL()
	}
	return res
}
