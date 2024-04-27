package schema

import (
	"time"

	"github.com/uptrace/bun"
)

type Song struct {
	bun.BaseModel `bun:"table:songs,alias:s"`

	ID                          string                        `bun:",pk,default:cuid()"`
	CircleID                    string                        `bun:"circle_id"`
	Circle                      *Circle                       `bun:"rel:belongs-to,join:circle_id=id"`
	AlbumID                     string                        `bun:"album_id"`
	Album                       *Album                        `bun:"rel:belongs-to,join:album_id=id"`
	Name                        string                        `bun:"name,nullzero,notnull"`
	NameReading                 string                        `bun:"name_reading"`
	Slug                        string                        `bun:"slug,nullzero,notnull,unique,default:gen_random_uuid()"`
	DiscNumber                  int                           `bun:"disc_number,nullzero,notnull,default:1"`
	TrackNumber                 int                           `bun:"track_number,nullzero,notnull"`
	ReleaseDate                 *time.Time                    `bun:"release_date"`
	Length                      int                           `bun:"length,nullzero"`
	BPM                         int                           `bun:"bpm,nullzero"`
	Description                 string                        `bun:"description"`
	DisplayComposer             string                        `bun:"display_composer"`
	DisplayArranger             string                        `bun:"display_arranger"`
	DisplayRearranger           string                        `bun:"display_rearranger"`
	DisplayLyricist             string                        `bun:"display_lyricist"`
	DisplayVocalist             string                        `bun:"display_vocalist"`
	DisplayOriginalSong         string                        `bun:"display_original_song"`
	PublishedAt                 *time.Time                    `bun:"published_at"`
	ArchivedAt                  *time.Time                    `bun:"archived_at"`
	CreatedAt                   time.Time                     `bun:"created_at,notnull,default:current_timestamp"`
	UpdatedAt                   time.Time                     `bun:"updated_at,notnull,default:current_timestamp"`
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
}
