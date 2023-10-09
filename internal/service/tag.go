package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type TagService struct {
	tRepo repository.TagRepository
}

func TagServiceProvider(tRepo repository.TagRepository) *TagService {
	return &TagService{tRepo: tRepo}
}

func (s *TagService) All(ctx context.Context) (entity.Tags, error) {
	tags, err := s.tRepo.FindAll(ctx)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return tags, nil
}
