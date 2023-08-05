package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type AlbumService struct {
	aRepo domain.AlbumRepository
}

func AlbumServiceProvider(aRepo domain.AlbumRepository) *AlbumService {
	return &AlbumService{aRepo: aRepo}
}

func (s *AlbumService) GetAlbumsByIDs(ctx context.Context, ids []string) (entity.Albums, error) {
	albums, err := s.aRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return albums, nil
}
