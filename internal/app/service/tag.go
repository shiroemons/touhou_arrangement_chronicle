package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type TagService struct {
	tRepo repository.TagRepository
}

func TagServiceProvider(tRepo repository.TagRepository) *TagService {
	return &TagService{tRepo: tRepo}
}

func (s *TagService) All(ctx context.Context) (schema.Tags, error) {
	tags, err := s.tRepo.FindAll(ctx)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return tags, nil
}
