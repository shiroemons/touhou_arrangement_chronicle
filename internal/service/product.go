package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ProductService struct {
	pRepo domain.ProductRepository
}

func ProductServiceProvider(pRepo domain.ProductRepository) *ProductService {
	return &ProductService{pRepo: pRepo}
}

func (s *ProductService) GetAll(ctx context.Context) (entity.Products, error) {
	products, err := s.pRepo.All(ctx)
	if err != nil {
		return make([]*entity.Product, 0), SrvErr(ctx, err.Error())
	}
	return products, nil
}

func (s *ProductService) GetProductsByIDs(ctx context.Context, ids []string) (entity.Products, error) {
	products, err := s.pRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return products, nil
}
