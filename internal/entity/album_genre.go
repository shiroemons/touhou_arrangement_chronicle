package entity

import (
	"time"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/uptrace/bun"
)

type AlbumGenre struct {
	bun.BaseModel `bun:"table:albums_genres,alias:alg"`

	ID        string    `bun:",pk,default:xid()"`
	AlbumID   string    `bun:"album_id,nullzero,notnull"`
	Album     *Album    `bun:"rel:belongs-to,join:album_id=id"`
	GenreID   string    `bun:"genre_id,nullzero,notnull"`
	Genre     *Genre    `bun:"rel:belongs-to,join:genre_id=id"`
	Locked    bool      `bun:"locked,nullzero,notnull,default:false"`
	CreatedAt time.Time `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt time.Time `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *AlbumGenre) ToGraphQL() *model.AlbumGenre {
	return &model.AlbumGenre{
		ID:     e.ID,
		Name:   e.Genre.Name,
		Locked: e.Locked,
	}
}

// AlbumGenres is a slice of AlbumGenre
type AlbumGenres []*AlbumGenre

// ToGraphQLs Convert to GraphQL Schema
func (arr AlbumGenres) ToGraphQLs() []*model.AlbumGenre {
	res := make([]*model.AlbumGenre, 0, len(arr))
	for _, albumGenre := range arr {
		res = append(res, albumGenre.ToGraphQL())
	}
	return res
}
