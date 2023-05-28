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
	CircleLoaderProvider,
)

var Module = fx.Provide(
	LoadersProvider,
)
