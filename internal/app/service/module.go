package service

import (
	"go.uber.org/fx"
)

var Module = fx.Provide(
	ProductServiceProvider,
	OriginalSongServiceProvider,
	EventSeriesServiceProvider,
	EventServiceProvider,
	SubEventServiceProvider,
	CircleServiceProvider,
	ArtistServiceProvider,
	TagServiceProvider,
	GenreServiceProvider,
	AlbumServiceProvider,
	SongServiceProvider,
)
