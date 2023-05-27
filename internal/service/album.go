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

func (s *AlbumService) Get(ctx context.Context, id string) (*entity.Album, error) {
	return s.aRepo.FindByID(ctx, id)
}
