package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type GenreService struct {
	gRepo domain.GenreRepository
}

func GenreServiceProvider(gRepo domain.GenreRepository) *GenreService {
	return &GenreService{gRepo: gRepo}
}

func (s *GenreService) All(ctx context.Context) (entity.Genres, error) {
	return s.gRepo.FindAll(ctx)
}