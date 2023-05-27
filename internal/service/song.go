package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongService struct {
	sRepo domain.SongRepository
}

func SongServiceProvider(sRepo domain.SongRepository) *SongService {
	return &SongService{sRepo: sRepo}
}

// Get is find song by id
func (srv *SongService) Get(ctx context.Context, id string) (*entity.Song, error) {
	return srv.sRepo.FindByID(ctx, id)
}
