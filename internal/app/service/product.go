package service

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/model/schema"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

type ProductService struct {
	pRepo repository.ProductRepository
}

func ProductServiceProvider(pRepo repository.ProductRepository) *ProductService {
	return &ProductService{pRepo: pRepo}
}

func (s *ProductService) GetAll(ctx context.Context) (schema.Products, error) {
	products, err := s.pRepo.All(ctx)
	if err != nil {
		return make([]*schema.Product, 0), SrvErr(ctx, err.Error())
	}
	return products, nil
}

func (s *ProductService) GetProductsByIDs(ctx context.Context, ids []string) (schema.Products, error) {
	products, err := s.pRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return products, nil
}
