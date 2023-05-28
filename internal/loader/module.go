package loader

import (
	"go.uber.org/fx"
)

var InitModule = fx.Provide(
	ProductLoaderProvider,
	EventLoaderProvider,
	SubEventLoaderProvider,
	AlbumLoaderProvider,
	SongLoaderProvider,
)

var Module = fx.Provide(
	LoadersProvider,
)
