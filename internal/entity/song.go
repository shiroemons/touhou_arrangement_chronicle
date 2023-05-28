package entity

import (
	"time"

	"github.com/samber/lo"
	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
)

type Song struct {
	bun.BaseModel `bun:"table:songs,alias:s"`

	ID                          string                        `bun:",pk,default:xid()"`
	CircleID                    string                        `bun:"circle_id,nullzero,notnull,default:''"`
	Circle                      *Circle                       `bun:"rel:belongs-to,join:circle_id=id"`
	AlbumID                     string                        `bun:"album_id,nullzero,notnull,default:''"`
	Album                       *Album                        `bun:"rel:belongs-to,join:album_id=id"`
	Name                        string                        `bun:"name,nullzero,notnull"`
	Slug                        string                        `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	DiscNumber                  int                           `bun:"disc_number,nullzero,notnull,default:1"`
	TrackNumber                 int                           `bun:"track_number,nullzero,notnull"`
	ReleaseDate                 *time.Time                    `bun:"release_date"`
	SearchEnabled               bool                          `bun:"search_enabled,nullzero,notnull,default:true"`
	Length                      int                           `bun:"length,nullzero"`
	BPM                         int                           `bun:"bpm,nullzero"`
	Description                 string                        `bun:"description,nullzero,notnull,default:''"`
	DisplayComposer             string                        `bun:"display_composer,nullzero,notnull,default:''"`
	DisplayArranger             string                        `bun:"display_arranger,nullzero,notnull,default:''"`
	DisplayRearranger           string                        `bun:"display_rearranger,nullzero,notnull,default:''"`
	DisplayLyricist             string                        `bun:"display_lyricist,nullzero,notnull,default:''"`
	DisplayVocalist             string                        `bun:"display_vocalist,nullzero,notnull,default:''"`
	DisplayOriginalSong         string                        `bun:"display_original_song,nullzero,notnull,default:''"`
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
	var originalSongs []*model.OriginalSong
	for _, v := range e.OriginalSongs {
		originalSongs = append(originalSongs, v.ToGraphQL())
	}
	var arrangeCircles []*model.Circle
	for _, v := range e.ArrangeCircles {
		arrangeCircles = append(arrangeCircles, v.ToGraphQL())
	}
	var arrangers []*model.Artist
	for _, v := range e.Arrangers {
		arrangers = append(arrangers, v.ToGraphQL())
	}
	var composers []*model.Artist
	for _, v := range e.Composers {
		composers = append(composers, v.ToGraphQL())
	}
	var lyricists []*model.Artist
	for _, v := range e.Lyricists {
		lyricists = append(lyricists, v.ToGraphQL())
	}
	var reArrangers []*model.Artist
	for _, v := range e.ReArrangers {
		reArrangers = append(reArrangers, v.ToGraphQL())
	}
	var vocalists []*model.Artist
	for _, v := range e.Vocalists {
		vocalists = append(vocalists, v.ToGraphQL())
	}
	var distributionServiceURLs []*model.SongDistributionServiceURL
	for _, v := range e.SongDistributionServiceURLs {
		distributionServiceURLs = append(distributionServiceURLs, v.ToGraphQL())
	}
	var isrcs []*model.Isrc
	for _, v := range e.SongISRCs {
		isrcs = append(isrcs, v.ToGraphQL())
	}

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
