package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type EventSeriesService struct {
	esRepo domain.EventSeriesRepository
}

func EventSeriesServiceProvider(esRepo domain.EventSeriesRepository) *EventSeriesService {
	return &EventSeriesService{esRepo: esRepo}
}

func (srv *EventSeriesService) GetAll(ctx context.Context) (entity.EventSeriesArr, error) {
	eventSeries, err := srv.esRepo.All(ctx)
	if err != nil {
		return make([]*entity.EventSeries, 0), err
	}
	return eventSeries, nil
}

func (srv *EventSeriesService) GetEventSeriesByIDs(ctx context.Context, ids []string) (entity.EventSeriesArr, error) {
	eventSeries, err := srv.esRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return eventSeries, nil
}
