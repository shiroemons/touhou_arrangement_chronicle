package repository

import (
	"go.uber.org/fx"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/domain"
)

var Module = fx.Provide(
	fx.Annotate(NewTxRepository, fx.As(new(domain.TxRepository))),
	fx.Annotate(NewProductRepository, fx.As(new(domain.ProductRepository))),
	fx.Annotate(NewOriginalSongRepository, fx.As(new(domain.OriginalSongRepository))),
	fx.Annotate(NewAlbumRepository, fx.As(new(domain.AlbumRepository))),
	fx.Annotate(NewAlbumCircleRepository, fx.As(new(domain.AlbumCircleRepository))),
	fx.Annotate(NewAlbumConsignmentShopRepository, fx.As(new(domain.AlbumConsignmentShopRepository))),
	fx.Annotate(NewAlbumDistributionServiceURLRepository, fx.As(new(domain.AlbumDistributionServiceURLRepository))),
	fx.Annotate(NewAlbumGenreRepository, fx.As(new(domain.AlbumGenreRepository))),
	fx.Annotate(NewAlbumTagRepository, fx.As(new(domain.AlbumTagRepository))),
	fx.Annotate(NewAlbumUPCRepository, fx.As(new(domain.AlbumUPCRepository))),
	fx.Annotate(NewArtistRepository, fx.As(new(domain.ArtistRepository))),
	fx.Annotate(NewCircleRepository, fx.As(new(domain.CircleRepository))),
	fx.Annotate(NewCircleGenreRepository, fx.As(new(domain.CircleGenreRepository))),
	fx.Annotate(NewCircleTagRepository, fx.As(new(domain.CircleTagRepository))),
	fx.Annotate(NewEventRepository, fx.As(new(domain.EventRepository))),
	fx.Annotate(NewEventSeriesRepository, fx.As(new(domain.EventSeriesRepository))),
	fx.Annotate(NewGenreRepository, fx.As(new(domain.GenreRepository))),
	fx.Annotate(NewOriginalSongDistributionServiceURLRepository, fx.As(new(domain.OriginalSongDistributionServiceURLRepository))),
	fx.Annotate(NewProductDistributionServiceURLRepository, fx.As(new(domain.ProductDistributionServiceURLRepository))),
	fx.Annotate(NewSongRepository, fx.As(new(domain.SongRepository))),
	fx.Annotate(NewSongArrangeCircleRepository, fx.As(new(domain.SongArrangeCircleRepository))),
	fx.Annotate(NewSongArrangerRepository, fx.As(new(domain.SongArrangerRepository))),
	fx.Annotate(NewSongCircleRepository, fx.As(new(domain.SongCircleRepository))),
	fx.Annotate(NewSongComposerRepository, fx.As(new(domain.SongComposerRepository))),
	fx.Annotate(NewSongDistributionServiceURLRepository, fx.As(new(domain.SongDistributionServiceURLRepository))),
	fx.Annotate(NewSongGenreRepository, fx.As(new(domain.SongGenreRepository))),
	fx.Annotate(NewSongISRCRepository, fx.As(new(domain.SongISRCRepository))),
	fx.Annotate(NewSongLyricistRepository, fx.As(new(domain.SongLyricistRepository))),
	fx.Annotate(NewSongOriginalSongRepository, fx.As(new(domain.SongOriginalSongRepository))),
	fx.Annotate(NewSongRearrangerRepository, fx.As(new(domain.SongRearrangerRepository))),
	fx.Annotate(NewSongTagRepository, fx.As(new(domain.SongTagRepository))),
	fx.Annotate(NewSongVocalistRepository, fx.As(new(domain.SongVocalistRepository))),
	fx.Annotate(NewSubEventRepository, fx.As(new(domain.SubEventRepository))),
	fx.Annotate(NewTagRepository, fx.As(new(domain.TagRepository))),
)
