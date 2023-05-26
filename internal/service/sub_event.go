package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type SubEventService struct {
	seRepo domain.SubEventRepository
}

func SubEventServiceProvider(seRepo domain.SubEventRepository) *SubEventService {
	return &SubEventService{seRepo: seRepo}
}

func (s *SubEventService) Get(ctx context.Context, id string) (*entity.SubEvent, error) {
	subEvent, err := s.seRepo.FindByID(ctx, id)
	if err != nil {
		return &entity.SubEvent{}, SrvErr(ctx, err.Error())
	}
	return subEvent, nil
}
