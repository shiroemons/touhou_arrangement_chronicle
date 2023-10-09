package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type AlbumService struct {
	aRepo repository.AlbumRepository
}

func AlbumServiceProvider(aRepo repository.AlbumRepository) *AlbumService {
	return &AlbumService{aRepo: aRepo}
}

func (s *AlbumService) GetAlbumsByIDs(ctx context.Context, ids []string) (schema.Albums, error) {
	albums, err := s.aRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return albums, nil
}
