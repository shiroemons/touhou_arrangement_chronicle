package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type AlbumCircleRepository interface {
	Add(ctx context.Context, albumCircle *schema.AlbumCircle) (*schema.AlbumCircle, error)
	Remove(ctx context.Context, albumCircle *schema.AlbumCircle) error
}
