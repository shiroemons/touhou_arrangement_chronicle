package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumTagRepository interface {
	Add(ctx context.Context, tag *entity.AlbumTag) (*entity.AlbumTag, error)
	Remove(ctx context.Context, tag *entity.AlbumTag) error
}
