package entity

import (
	"time"

	"github.com/uptrace/bun"
)

type TracksArrangeCircles struct {
	bun.BaseModel `bun:"table:tracks_arrange_circles,alias:tac"`

	TrackID   string    `bun:"track_id,pk,nullzero,notnull"`
	Track     *Track    `bun:"rel:belongs-to,join:track_id=id"`
	CircleID  string    `bun:"circle_id,pk,nullzero,notnull"`
	Circle    *Circle   `bun:"rel:belongs-to,join:circle_id=id"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}
