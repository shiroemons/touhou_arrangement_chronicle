package repository

import (
	"go.uber.org/fx"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain/repository"
)

var Module = fx.Provide(
	fx.Annotate(NewTxRepository, fx.As(new(repository.TxRepository))),
	fx.Annotate(NewProductRepository, fx.As(new(repository.ProductRepository))),
	fx.Annotate(NewOriginalSongRepository, fx.As(new(repository.OriginalSongRepository))),
	fx.Annotate(NewAlbumRepository, fx.As(new(repository.AlbumRepository))),
	fx.Annotate(NewAlbumCircleRepository, fx.As(new(repository.AlbumCircleRepository))),
	fx.Annotate(NewAlbumConsignmentShopRepository, fx.As(new(repository.AlbumConsignmentShopRepository))),
	fx.Annotate(NewAlbumDistributionServiceURLRepository, fx.As(new(repository.AlbumDistributionServiceURLRepository))),
	fx.Annotate(NewAlbumGenreRepository, fx.As(new(repository.AlbumGenreRepository))),
	fx.Annotate(NewAlbumTagRepository, fx.As(new(repository.AlbumTagRepository))),
	fx.Annotate(NewAlbumUPCRepository, fx.As(new(repository.AlbumUPCRepository))),
	fx.Annotate(NewArtistRepository, fx.As(new(repository.ArtistRepository))),
	fx.Annotate(NewCircleRepository, fx.As(new(repository.CircleRepository))),
	fx.Annotate(NewCircleGenreRepository, fx.As(new(repository.CircleGenreRepository))),
	fx.Annotate(NewCircleTagRepository, fx.As(new(repository.CircleTagRepository))),
	fx.Annotate(NewEventRepository, fx.As(new(repository.EventRepository))),
	fx.Annotate(NewEventSeriesRepository, fx.As(new(repository.EventSeriesRepository))),
	fx.Annotate(NewGenreRepository, fx.As(new(repository.GenreRepository))),
	fx.Annotate(NewOriginalSongDistributionServiceURLRepository, fx.As(new(repository.OriginalSongDistributionServiceURLRepository))),
	fx.Annotate(NewProductDistributionServiceURLRepository, fx.As(new(repository.ProductDistributionServiceURLRepository))),
	fx.Annotate(NewSongRepository, fx.As(new(repository.SongRepository))),
	fx.Annotate(NewSongArrangeCircleRepository, fx.As(new(repository.SongArrangeCircleRepository))),
	fx.Annotate(NewSongArrangerRepository, fx.As(new(repository.SongArrangerRepository))),
	fx.Annotate(NewSongCircleRepository, fx.As(new(repository.SongCircleRepository))),
	fx.Annotate(NewSongComposerRepository, fx.As(new(repository.SongComposerRepository))),
	fx.Annotate(NewSongDistributionServiceURLRepository, fx.As(new(repository.SongDistributionServiceURLRepository))),
	fx.Annotate(NewSongGenreRepository, fx.As(new(repository.SongGenreRepository))),
	fx.Annotate(NewSongISRCRepository, fx.As(new(repository.SongISRCRepository))),
	fx.Annotate(NewSongLyricistRepository, fx.As(new(repository.SongLyricistRepository))),
	fx.Annotate(NewSongOriginalSongRepository, fx.As(new(repository.SongOriginalSongRepository))),
	fx.Annotate(NewSongRearrangerRepository, fx.As(new(repository.SongRearrangerRepository))),
	fx.Annotate(NewSongTagRepository, fx.As(new(repository.SongTagRepository))),
	fx.Annotate(NewSongVocalistRepository, fx.As(new(repository.SongVocalistRepository))),
	fx.Annotate(NewSubEventRepository, fx.As(new(repository.SubEventRepository))),
	fx.Annotate(NewTagRepository, fx.As(new(repository.TagRepository))),
)
