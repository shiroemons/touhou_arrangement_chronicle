package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventService struct {
	eRepo domain.EventRepository
}

func EventServiceProvider(eRepo domain.EventRepository) *EventService {
	return &EventService{eRepo: eRepo}
}

func (s *EventService) GetEventsByIDs(ctx context.Context, ids []string) (entity.Events, error) {
	events, err := s.eRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return events, nil
}
