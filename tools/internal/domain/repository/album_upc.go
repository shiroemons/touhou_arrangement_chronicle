package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/tools/internal/domain/model/schema"
)

type AlbumUPCRepository interface {
	Add(ctx context.Context, upc *schema.AlbumUPC) (*schema.AlbumUPC, error)
	Remove(ctx context.Context, upc *schema.AlbumUPC) error
}
