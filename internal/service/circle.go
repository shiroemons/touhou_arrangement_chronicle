package service

import (
	"context"
	"strings"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleService struct {
	cRepo repository.CircleRepository
}

func CircleServiceProvider(cRepo repository.CircleRepository) *CircleService {
	return &CircleService{cRepo: cRepo}
}

func (s *CircleService) GetCirclesByIDs(ctx context.Context, ids []string) (entity.Circles, error) {
	circles, err := s.cRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return circles, nil
}

func (s *CircleService) GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Circles, error) {
	// initialTypeを小文字の文字列に変換する
	initialTypeString := strings.ToLower(string(initialType))

	return s.cRepo.FindByInitialType(ctx, initialTypeString)
}
