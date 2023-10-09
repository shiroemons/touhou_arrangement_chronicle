package repository

import (
	"context"
	"database/sql"
	"log"

	"github.com/uptrace/bun"
)

type key int

const (
	TxCtxKey key = iota
)

type TxRepository struct {
	db *bun.DB
}

func NewTxRepository(db *bun.DB) *TxRepository {
	return &TxRepository{db: db}
}

func (r *TxRepository) DoInTx(ctx context.Context, opts *sql.TxOptions, fn func(ctx context.Context, tx bun.Tx) error) error {
	tx, err := r.db.BeginTx(ctx, opts)
	if err != nil {
		return err
	}

	c := context.WithValue(ctx, TxCtxKey, tx)

	var done bool

	defer func() {
		if !done {
			if err := tx.Rollback(); err != nil {
				log.Printf("Failed to rollback transaction: %v", err)
			}
		}
	}()

	if err := fn(c, tx); err != nil {
		return err
	}

	done = true
	return tx.Commit()
}
