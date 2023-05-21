package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductRepository interface {
	FindByID(ctx context.Context, id string) (*entity.Product, error)
}
