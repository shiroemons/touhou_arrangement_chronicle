package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type AlbumConsignmentShopRepository interface {
	Add(ctx context.Context, shop *schema.AlbumConsignmentShop) (*schema.AlbumConsignmentShop, error)
	Remove(ctx context.Context, shop *schema.AlbumConsignmentShop) error
}
