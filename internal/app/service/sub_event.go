package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type SubEventService struct {
	seRepo repository.SubEventRepository
}

func SubEventServiceProvider(seRepo repository.SubEventRepository) *SubEventService {
	return &SubEventService{seRepo: seRepo}
}

func (s *SubEventService) GetSubEventsByIDs(ctx context.Context, ids []string) (schema.SubEvents, error) {
	subEvents, err := s.seRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return subEvents, nil
}
