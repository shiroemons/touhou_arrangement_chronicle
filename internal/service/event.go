package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type EventService struct {
	eRepo repository.EventRepository
}

func EventServiceProvider(eRepo repository.EventRepository) *EventService {
	return &EventService{eRepo: eRepo}
}

func (s *EventService) GetEventsByIDs(ctx context.Context, ids []string) (schema.Events, error) {
	events, err := s.eRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return events, nil
}
