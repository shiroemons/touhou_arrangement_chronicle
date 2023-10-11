package repository

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
)

type AlbumTagRepository interface {
	Add(ctx context.Context, tag *schema.AlbumTag) (*schema.AlbumTag, error)
	Remove(ctx context.Context, tag *schema.AlbumTag) error
}
