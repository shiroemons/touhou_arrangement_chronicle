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

func (s *EventService) Get(ctx context.Context, id string) (*entity.Event, error) {
	event, err := s.eRepo.FindByID(ctx, id)
	if err != nil {
		return &entity.Event{}, SrvErr(ctx, err.Error())
	}
	return event, nil
}
