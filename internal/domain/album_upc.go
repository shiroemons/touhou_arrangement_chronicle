package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumUPCRepository interface {
	Add(ctx context.Context, upc *entity.AlbumUPC) (*entity.AlbumUPC, error)
	Remove(ctx context.Context, upc *entity.AlbumUPC) error
}
