package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumConsignmentShopRepository interface {
	Add(ctx context.Context, shop *entity.AlbumConsignmentShop) (*entity.AlbumConsignmentShop, error)
	Remove(ctx context.Context, shop *entity.AlbumConsignmentShop) error
}
