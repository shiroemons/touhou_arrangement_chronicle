package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type GenreService struct {
	gRepo repository.GenreRepository
}

func GenreServiceProvider(gRepo repository.GenreRepository) *GenreService {
	return &GenreService{gRepo: gRepo}
}

func (s *GenreService) All(ctx context.Context) (entity.Genres, error) {
	genres, err := s.gRepo.FindAll(ctx)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return genres, nil
}
