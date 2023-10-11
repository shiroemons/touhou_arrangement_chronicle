package schema

import (
	"time"

	"github.com/samber/lo"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Song struct {
	bun.BaseModel `bun:"table:songs,alias:s"`

	ID                          string                        `bun:",pk,default:cuid()"`
	CircleID                    string                        `bun:"circle_id"`
	Circle                      *Circle                       `bun:"rel:belongs-to,join:circle_id=id"`
	AlbumID                     string                        `bun:"album_id"`
	Album                       *Album                        `bun:"rel:belongs-to,join:album_id=id"`
	Name                        string                        `bun:"name,nullzero,notnull"`
	Slug                        string                        `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	DiscNumber                  int                           `bun:"disc_number,nullzero,notnull,default:1"`
	TrackNumber                 int                           `bun:"track_number,nullzero,notnull"`
	ReleaseDate                 *time.Time                    `bun:"release_date"`
	SearchEnabled               bool                          `bun:"search_enabled,nullzero,notnull,default:true"`
	Length                      int                           `bun:"length,nullzero"`
	BPM                         int                           `bun:"bpm,nullzero"`
	Description                 string                        `bun:"description"`
	DisplayComposer             string                        `bun:"display_composer"`
	DisplayArranger             string                        `bun:"display_arranger"`
	DisplayRearranger           string                        `bun:"display_rearranger"`
	DisplayLyricist             string                        `bun:"display_lyricist"`
	DisplayVocalist             string                        `bun:"display_vocalist"`
	DisplayOriginalSong         string                        `bun:"display_original_song"`
	SongDistributionServiceURLs []*SongDistributionServiceURL `bun:"rel:has-many,join:id=song_id"`
	SongISRCs                   []*SongISRC                   `bun:"rel:has-many,join:id=song_id"`
	Genres                      []*SongGenre                  `bun:"rel:has-many,join:id=song_id"`
	Tags                        []*SongTag                    `bun:"rel:has-many,join:id=song_id"`
	OriginalSongs               []*OriginalSong               `bun:"m2m:songs_original_songs,join:Song=OriginalSong"`
	ArrangeCircles              []*Circle                     `bun:"m2m:songs_arrange_circles,join:Song=Circle"`
	Arrangers                   []*Artist                     `bun:"m2m:songs_arrangers,join:Song=Artist"`
	Composers                   []*Artist                     `bun:"m2m:songs_composers,join:Song=Artist"`
	Lyricists                   []*Artist                     `bun:"m2m:songs_lyricists,join:Song=Artist"`
	ReArrangers                 []*Artist                     `bun:"m2m:songs_rearrangers,join:Song=Artist"`
	Vocalists                   []*Artist                     `bun:"m2m:songs_vocalists,join:Song=Artist"`
	CreatedAt                   time.Time                     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                   time.Time                     `bun:"updated_at,notnull,default:current_timestamp"`
}

// ToGraphQL Convert to GraphQL Schema
func (e *Song) ToGraphQL() *model.Song {
	var releaseDate *string
	if e.ReleaseDate != nil {
		releaseDate = lo.ToPtr(e.ReleaseDate.Format("2006-01-02"))
	}

	originalSongs := ConvertSlice(e.OriginalSongs, func(v *OriginalSong) *model.OriginalSong { return v.ToGraphQL() })
	arrangeCircles := ConvertSlice(e.ArrangeCircles, func(v *Circle) *model.Circle { return v.ToGraphQL() })
	arrangers := ConvertSlice(e.Arrangers, func(v *Artist) *model.Artist { return v.ToGraphQL() })
	composers := ConvertSlice(e.Composers, func(v *Artist) *model.Artist { return v.ToGraphQL() })
	lyricists := ConvertSlice(e.Lyricists, func(v *Artist) *model.Artist { return v.ToGraphQL() })
	reArrangers := ConvertSlice(e.ReArrangers, func(v *Artist) *model.Artist { return v.ToGraphQL() })
	vocalists := ConvertSlice(e.Vocalists, func(v *Artist) *model.Artist { return v.ToGraphQL() })
	distributionServiceURLs := ConvertSlice(e.SongDistributionServiceURLs, func(v *SongDistributionServiceURL) *model.SongDistributionServiceURL { return v.ToGraphQL() })
	isrcs := ConvertSlice(e.SongISRCs, func(v *SongISRC) *model.Isrc { return v.ToGraphQL() })
	genres := ConvertSlice(e.Genres, func(v *SongGenre) *model.SongGenre { return v.ToGraphQL() })
	tags := ConvertSlice(e.Tags, func(v *SongTag) *model.SongTag { return v.ToGraphQL() })

	song := &model.Song{
		ID:                  e.ID,
		Name:                e.Name,
		Slug:                e.Slug,
		DiscNumber:          e.DiscNumber,
		TrackNumber:         e.TrackNumber,
		ReleaseDate:         releaseDate,
		SearchEnabled:       e.SearchEnabled,
		Description:         e.Description,
		DisplayComposer:     e.DisplayComposer,
		DisplayArranger:     e.DisplayArranger,
		DisplayRearranger:   e.DisplayRearranger,
		DisplayLyricist:     e.DisplayLyricist,
		DisplayVocalist:     e.DisplayVocalist,
		DisplayOriginalSong: e.DisplayOriginalSong,
		OriginalSongs:       originalSongs,
		ArrangeCircles:      arrangeCircles,
		Arrangers:           arrangers,
		Composers:           composers,
		Lyricists:           lyricists,
		Rearrangers:         reArrangers,
		Vocalists:           vocalists,
		DistributionUrls:    distributionServiceURLs,
		Isrcs:               isrcs,
		Genres:              genres,
		Tags:                tags,
	}
	if e.Length != 0 {
		song.Length = lo.ToPtr(e.Length)
	}
	if e.BPM != 0 {
		song.Bpm = lo.ToPtr(e.BPM)
	}
	if e.CircleID != "" {
		song.Circle = &model.Circle{ID: e.CircleID}
	}
	if e.AlbumID != "" {
		song.Album = &model.Album{ID: e.AlbumID}
	}

	return song
}

// Songs is a slice of Song
type Songs []*Song

// ToGraphQLs Convert to GraphQL Schema
func (arr Songs) ToGraphQLs() []*model.Song {
	res := make([]*model.Song, len(arr))
	for i, v := range arr {
		res[i] = v.ToGraphQL()
	}
	return res
}
