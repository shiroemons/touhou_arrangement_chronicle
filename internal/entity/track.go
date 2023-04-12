package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type Track struct {
	bun.BaseModel `bun:"table:tracks,alias:t"`

	ID                           string                         `bun:",pk"`
	AlbumID                      string                         `bun:"album_id,nullzero,notnull"`
	Album                        Album                          `bun:"rel:belongs-to,join:album_id=id"`
	Name                         string                         `bun:"name,nullzero,notnull"`
	DiscNumber                   int                            `bun:"disc_number,nullzero,notnull,default:1"`
	TrackNumber                  int                            `bun:"track_number,nullzero,notnull"`
	ReleaseDate                  time.Time                      `bun:"release_date"`
	SearchEnabled                bool                           `bun:"search_enabled,nullzero,notnull,default:true"`
	Length                       int                            `bun:"length,nullzero"`
	BPM                          int                            `bun:"bpm,nullzero"`
	DisplayComposer              string                         `bun:"display_composer,nullzero,notnull,default:''"`
	DisplayArranger              string                         `bun:"display_arranger,nullzero,notnull,default:''"`
	DisplayRearranger            string                         `bun:"display_rearranger,nullzero,notnull,default:''"`
	DisplayLyricist              string                         `bun:"display_lyricist,nullzero,notnull,default:''"`
	DisplayVocalist              string                         `bun:"display_vocalist,nullzero,notnull,default:''"`
	DisplayOriginalSong          string                         `bun:"display_original_song,nullzero,notnull,default:''"`
	TrackDistributionServiceURLs []*TrackDistributionServiceURL `bun:"rel:has-many,join:id=track_id"`
	TrackISRCs                   []*TrackISRC                   `bun:"rel:has-many,join:id=track_id"`
	OriginalSongs                []OriginalSong                 `bun:"m2m:tracks_original_songs,join:Track=OriginalSong"`
	ArrangeCircles               []Circle                       `bun:"m2m:tracks_arrange_circles,join:Track=Circle"`
	Arrangers                    []Artist                       `bun:"m2m:tracks_arrangers,join:Track=Artist"`
	Composers                    []Artist                       `bun:"m2m:tracks_composers,join:Track=Artist"`
	Lyricists                    []Artist                       `bun:"m2m:tracks_lyricists,join:Track=Artist"`
	ReArrangers                  []Artist                       `bun:"m2m:tracks_rearrangers,join:Track=Artist"`
	Vocalists                    []Artist                       `bun:"m2m:tracks_vocalists,join:Track=Artist"`
	GenreTags                    []Tag                          `bun:"m2m:tracks_genres,join:Track=GenreTag"`
	Tags                         []Tag                          `bun:"m2m:tracks_tags,join:Track=Tag"`
	CreatedAt                    time.Time                      `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                    time.Time                      `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Track)(nil)

func (e *Track) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
