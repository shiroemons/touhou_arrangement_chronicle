package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type OriginalSongService struct {
	osRepo domain.OriginalSongRepository
}

func OriginalSongServiceProvider(osRepo domain.OriginalSongRepository) *OriginalSongService {
	return &OriginalSongService{osRepo: osRepo}
}

func (s *OriginalSongService) GetAll(ctx context.Context) (entity.OriginalSongs, error) {
	originalSongs, err := s.osRepo.All(ctx)
	if err != nil {
		return make([]*entity.OriginalSong, 0), SrvErr(ctx, err.Error())
	}
	return originalSongs, nil
}

func (s *OriginalSongService) GetOriginalSongsByIDs(ctx context.Context, ids []string) (entity.OriginalSongs, error) {
	originalSongs, err := s.osRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return originalSongs, nil
}
