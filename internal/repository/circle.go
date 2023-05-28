package repository

import (
	"context"

	"github.com/uptrace/bun"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type CircleRepository struct {
	db *bun.DB
}

func NewCircleRepository(db *bun.DB) *CircleRepository {
	return &CircleRepository{db: db}
}

func (r *CircleRepository) Create(ctx context.Context, circle *entity.Circle) (*entity.Circle, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewInsert().Model(circle).Exec(ctx); err != nil {
			return nil, err
		}
		return circle, nil
	}
	if _, err := r.db.NewInsert().Model(circle).Exec(ctx); err != nil {
		return nil, err
	}
	return circle, nil
}

func (r *CircleRepository) Update(ctx context.Context, circle *entity.Circle) (*entity.Circle, error) {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewUpdate().Model(circle).WherePK().Exec(ctx); err != nil {
			return nil, err
		}
		return circle, nil
	}
	if _, err := r.db.NewUpdate().Model(circle).WherePK().Exec(ctx); err != nil {
		return nil, err
	}
	return circle, nil
}

func (r *CircleRepository) Delete(ctx context.Context, circle *entity.Circle) error {
	tx, ok := ctx.Value(TxCtxKey).(*bun.Tx)
	if ok {
		if _, err := tx.NewDelete().Model(circle).WherePK().Exec(ctx); err != nil {
			return err
		}
		return nil
	}
	if _, err := r.db.NewDelete().Model(circle).WherePK().Exec(ctx); err != nil {
		return err
	}
	return nil
}

func (r *CircleRepository) FindByID(ctx context.Context, id string) (*entity.Circle, error) {
	circle := new(entity.Circle)
	err := r.db.NewSelect().Model(circle).
		Where("id = ?", id).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return circle, nil
}

func (r *CircleRepository) FindByInitialType(ctx context.Context, initialType string) ([]*entity.Circle, error) {
	var circles []*entity.Circle

	err := r.db.NewSelect().Model(&circles).
		Where("initial_letter_type = ?", initialType).
		Order("name").
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	return circles, nil
}

// GetMapInIDs は、指定したIDのCircleを取得します。
func (r *CircleRepository) GetMapInIDs(ctx context.Context, ids []string) (map[string]*entity.Circle, error) {
	circles := make([]*entity.Circle, 0)
	err := r.db.NewSelect().Model(&circles).
		Where("c.id IN (?)", bun.In(ids)).
		Scan(ctx)
	if err != nil {
		return nil, err
	}
	circleMap := make(map[string]*entity.Circle, len(circles))
	for _, v := range circles {
		circleMap[v.ID] = v
	}
	return circleMap, nil
}
