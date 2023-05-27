package domain

import (
	"context"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleRepository interface {
	Create(ctx context.Context, circle *entity.Circle) (*entity.Circle, error)
	Update(ctx context.Context, circle *entity.Circle) (*entity.Circle, error)
	Delete(ctx context.Context, circle *entity.Circle) error
	FindByID(ctx context.Context, id string) (*entity.Circle, error)
	FindByInitialType(ctx context.Context, initialType string) ([]*entity.Circle, error)
}

type CircleService interface {
	Get(ctx context.Context, id string) (*entity.Circle, error)
	GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Circles, error)
}
