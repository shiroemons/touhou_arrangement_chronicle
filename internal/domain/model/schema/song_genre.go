package schema

import (
	"time"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type SongGenre struct {
	bun.BaseModel `bun:"table:songs_genres,alias:sg"`

	ID        string    `bun:",pk,default:cuid()"`
	SongID    string    `bun:"song_id,nullzero,notnull"`
	Song      *Song     `bun:"rel:belongs-to,join:song_id=id"`
	GenreID   string    `bun:"genre_id,nullzero,notnull"`
	Genre     *Genre    `bun:"rel:belongs-to,join:genre_id=id"`
	Locked    bool      `bun:"locked,notnull"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *SongGenre) ToGraphQL() *model.SongGenre {
	return &model.SongGenre{
		ID:     e.ID,
		Name:   e.Genre.Name,
		Locked: e.Locked,
	}
}

// SongGenres is a slice of SongGenre
type SongGenres []*SongGenre

// ToGraphQLs Convert to GraphQL Schema
func (arr SongGenres) ToGraphQLs() []*model.SongGenre {
	res := make([]*model.SongGenre, 0, len(arr))
	for _, v := range arr {
		res = append(res, v.ToGraphQL())
	}
	return res
}
