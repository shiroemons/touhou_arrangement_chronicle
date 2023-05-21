package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumCircleRepository interface {
	Add(ctx context.Context, albumCircle *entity.AlbumCircle) (*entity.AlbumCircle, error)
	Remove(ctx context.Context, albumCircle *entity.AlbumCircle) error
}
