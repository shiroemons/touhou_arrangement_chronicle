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

func (s *SubEventService) GetSubEventsByIDs(ctx context.Context, ids []string) (entity.SubEvents, error) {
	subEvents, err := s.seRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return subEvents, nil
}
