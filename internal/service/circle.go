package service

import (
	"context"
	"strings"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleService struct {
	cRepo domain.CircleRepository
}

func CircleServiceProvider(cRepo domain.CircleRepository) *CircleService {
	return &CircleService{cRepo: cRepo}
}

func (s *CircleService) Get(ctx context.Context, id string) (*entity.Circle, error) {
	return s.cRepo.FindByID(ctx, id)
}

func (s *CircleService) GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Circles, error) {
	// initialTypeを小文字の文字列に変換する
	initialTypeString := strings.ToLower(string(initialType))

	return s.cRepo.FindByInitialType(ctx, initialTypeString)
}
