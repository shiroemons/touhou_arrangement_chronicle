package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SongService struct {
	sRepo repository.SongRepository
}

func SongServiceProvider(sRepo repository.SongRepository) *SongService {
	return &SongService{sRepo: sRepo}
}

func (srv *SongService) GetSongsByIDs(ctx context.Context, ids []string) (entity.Songs, error) {
	songs, err := srv.sRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return songs, nil
}
