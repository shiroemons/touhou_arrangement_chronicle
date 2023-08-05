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

func (s *ArtistService) GetArtistsByIDs(ctx context.Context, ids []string) (entity.Artists, error) {
	artists, err := s.aRepo.FindByIDs(ctx, ids)
	if err != nil {
		return nil, SrvErr(ctx, err.Error())
	}
	return artists, nil
}

func (s *ArtistService) GetAllByInitialLetterType(ctx context.Context, initialType model.InitialLetterType) (entity.Artists, error) {
	// initialTypeを小文字の文字列に変換する
	initialTypeString := strings.ToLower(string(initialType))

	return s.aRepo.FindByInitialType(ctx, initialTypeString)
}
