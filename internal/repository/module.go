package repository

import (
	"go.uber.org/fx"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
)

var Module = fx.Provide(
	fx.Annotate(TxRepositoryProvider, fx.As(new(domain.TxRepository))),
)
