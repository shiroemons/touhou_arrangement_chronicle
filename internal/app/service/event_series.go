package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type EventSeriesService struct {
	esRepo repository.EventSeriesRepository
}

func EventSeriesServiceProvider(esRepo repository.EventSeriesRepository) *EventSeriesService {
	return &EventSeriesService{esRepo: esRepo}
}

func (srv *EventSeriesService) GetAll(ctx context.Context) (schema.EventSeriesArr, error) {
	eventSeries, err := srv.esRepo.All(ctx)
	if err != nil {
		return make([]*schema.EventSeries, 0), err
	}
	return eventSeries, nil
}

func (srv *EventSeriesService) GetEventSeriesByIDs(ctx context.Context, ids []string) (schema.EventSeriesArr, error) {
	eventSeries, err := srv.esRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return eventSeries, nil
}
