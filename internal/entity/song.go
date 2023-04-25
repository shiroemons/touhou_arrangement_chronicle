package entity

import (
	"context"
	"time"

	"github.com/rs/xid"
	"github.com/uptrace/bun"
)

type Song struct {
	bun.BaseModel `bun:"table:songs,alias:t"`

	ID                          string                        `bun:",pk"`
	AlbumID                     string                        `bun:"album_id,nullzero,notnull"`
	Album                       *Album                        `bun:"rel:belongs-to,join:album_id=id"`
	Name                        string                        `bun:"name,nullzero,notnull"`
	DiscNumber                  int                           `bun:"disc_number,nullzero,notnull,default:1"`
	TrackNumber                 int                           `bun:"track_number,nullzero,notnull"`
	ReleaseDate                 *time.Time                    `bun:"release_date"`
	SearchEnabled               bool                          `bun:"search_enabled,nullzero,notnull,default:true"`
	Length                      int                           `bun:"length,nullzero"`
	BPM                         int                           `bun:"bpm,nullzero"`
	DisplayComposer             string                        `bun:"display_composer,nullzero,notnull,default:''"`
	DisplayArranger             string                        `bun:"display_arranger,nullzero,notnull,default:''"`
	DisplayRearranger           string                        `bun:"display_rearranger,nullzero,notnull,default:''"`
	DisplayLyricist             string                        `bun:"display_lyricist,nullzero,notnull,default:''"`
	DisplayVocalist             string                        `bun:"display_vocalist,nullzero,notnull,default:''"`
	DisplayOriginalSong         string                        `bun:"display_original_song,nullzero,notnull,default:''"`
	SongDistributionServiceURLs []*SongDistributionServiceURL `bun:"rel:has-many,join:id=song_id"`
	SongISRCs                   []*SongISRC                   `bun:"rel:has-many,join:id=song_id"`
	OriginalSongs               []*OriginalSong               `bun:"m2m:songs_original_songs,join:Song=OriginalSong"`
	ArrangeCircles              []*Circle                     `bun:"m2m:songs_arrange_circles,join:Song=Circle"`
	Arrangers                   []*Artist                     `bun:"m2m:songs_arrangers,join:Song=Artist"`
	Composers                   []*Artist                     `bun:"m2m:songs_composers,join:Song=Artist"`
	Lyricists                   []*Artist                     `bun:"m2m:songs_lyricists,join:Song=Artist"`
	ReArrangers                 []*Artist                     `bun:"m2m:songs_rearrangers,join:Song=Artist"`
	Vocalists                   []*Artist                     `bun:"m2m:songs_vocalists,join:Song=Artist"`
	GenreTags                   []*Tag                        `bun:"m2m:songs_genres,join:Song=GenreTag"`
	Tags                        []*Tag                        `bun:"m2m:songs_tags,join:Song=Tag"`
	CreatedAt                   time.Time                     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                   time.Time                     `bun:"updated_at,notnull,default:current_timestamp"`
}

var _ bun.BeforeAppendModelHook = (*Song)(nil)

func (e *Song) BeforeAppendModel(_ context.Context, query bun.Query) error {
	switch query.(type) {
	case *bun.InsertQuery:
		if e.ID == "" {
			e.ID = xid.New().String()
		}
	}
	return nil
}
