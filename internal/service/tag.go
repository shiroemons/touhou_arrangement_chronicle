package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type TagService struct {
	tRepo domain.TagRepository
}

func TagServiceProvider(tRepo domain.TagRepository) *TagService {
	return &TagService{tRepo: tRepo}
}

func (s *TagService) All(ctx context.Context) (entity.Tags, error) {
	tags, err := s.tRepo.FindAll(ctx)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return tags, nil
}
