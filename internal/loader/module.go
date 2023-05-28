package loader

import (
	"go.uber.org/fx"
)

var InitModule = fx.Provide(
	ProductLoaderProvider,
	EventSeriesLoaderProvider,
	EventLoaderProvider,
	SubEventLoaderProvider,
	AlbumLoaderProvider,
	SongLoaderProvider,
)

var Module = fx.Provide(
	LoadersProvider,
)
