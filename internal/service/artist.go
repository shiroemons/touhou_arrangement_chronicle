package service

import (
	"context"
	"strings"

	"github.com/shiroemons/touhou_arrangement_chronicle/graph/model"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
	"github.com/shiroemons/touhou_arrangement_chronicle/internal/entity"
)

type ArtistService struct {
	aRepo domain.ArtistRepository
}

func ArtistServiceProvider(aRepo domain.ArtistRepository) *ArtistService {
	return &ArtistService{aRepo: aRepo}
}

func (s *ArtistService) Get(ctx context.Context, id string) (*entity.Artist, error) {
	return s.aRepo.FindByID(ctx, id)
}

func (s *ArtistService) GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Artists, error) {
	// initialTypeを小文字の文字列に変換する
	initialTypeString := strings.ToLower(string(initialType))

	return s.aRepo.FindByInitialType(ctx, initialTypeString)
}
