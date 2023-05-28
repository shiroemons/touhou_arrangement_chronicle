package loader

import (
	"go.uber.org/fx"
)

var InitModule = fx.Provide(
	ProductLoaderProvider,
	EventLoaderProvider,
	SubEventLoaderProvider,
)

var Module = fx.Provide(
	LoadersProvider,
)
