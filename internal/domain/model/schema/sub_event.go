package schema

import (
	"time"

	"github.com/samber/lo"
	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/uptrace/bun"
)

type SubEvent struct {
	bun.BaseModel `bun:"table:sub_events,alias:se"`

	ID          string     `bun:",pk,default:cuid()"`
	EventID     string     `bun:"event_id,nullzero,notnull"`
	Name        string     `bun:"name,nullzero,notnull"`
	DisplayName string     `bun:"display_name,nullzero,notnull"`
	Slug        string     `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	EventDate   *time.Time `bun:"event_date,nullzero,notnull"`
	EventStatus string     `bun:"event_status,nullzero,notnull,default:'scheduled'::event_status"`
	Description string     `bun:"description,nullzero,notnull,default:''"`
	CreatedAt   time.Time  `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt   time.Time  `bun:"updated_at,notnull,default:current_timestamp"`
}

func (e *SubEvent) ToGraphQL() *model.SubEvent {
	subEvent := &model.SubEvent{
		ID:          e.ID,
		Name:        e.Name,
		DisplayName: e.DisplayName,
		Slug:        e.Slug,
		Description: e.Description,
	}
	if e.EventDate != nil {
		subEvent.Date = lo.ToPtr(e.EventDate.Format("2006-01-02"))
	}
	if e.EventStatus != "" {
		subEvent.Status = model.EventStatus(e.EventStatus)
	}

	return subEvent
}

type SubEvents []*SubEvent

func (arr SubEvents) ToGraphQLs() []*model.SubEvent {
	res := make([]*model.SubEvent, len(arr))
	for i, v := range arr {
		res[i] = v.ToGraphQL()
	}
	return res
}
