class Song < ApplicationRecord
  acts_as_list scope: :album

  # 関連
  belongs_to :circle, optional: true
  belongs_to :album, optional: true
  belongs_to :album_disc, optional: true
  has_many :song_lyrics, dependent: :destroy
  has_many :song_bmps, dependent: :destroy
  has_many :song_isrcs, dependent: :destroy
  has_many :songs_arrange_circles, dependent: :destroy
  has_many :arrange_circles, -> { order(position: :asc) }, through: :songs_arrange_circles, source: :circle
  has_many :songs_original_songs, dependent: :destroy
  has_many :original_songs, through: :songs_original_songs
  has_many :songs_artist_roles, dependent: :destroy
  has_many :artist_names, through: :songs_artist_roles
  has_many :artist_roles, through: :songs_artist_roles
  has_many :songs_genres, dependent: :destroy
  has_many :genres, -> { order(position: :asc) }, through: :songs_genres
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, -> { order(position: :asc) }, through: :taggings
  has_many :streamable_urls, -> { order(position: :asc) }, as: :streamable, dependent: :destroy
  has_many :reference_urls, -> { order(position: :asc) }, as: :referenceable, dependent: :destroy

  # アーティスト役割ごとのアソシエーション
  has_many :arrangers, -> {
    select("DISTINCT ON (artist_names.id) artist_names.*, songs_artist_roles.position")
    .joins(:songs_artist_roles)
    .where(songs_artist_roles: { artist_role: ArtistRole.role_for("arranger") })
    .order("artist_names.id, songs_artist_roles.position ASC")
  }, through: :songs_artist_roles, source: :artist_name

  has_many :composers, -> {
    select("DISTINCT ON (artist_names.id) artist_names.*, songs_artist_roles.position")
    .joins(:songs_artist_roles)
    .where(songs_artist_roles: { artist_role: ArtistRole.role_for("composer") })
    .order("artist_names.id, songs_artist_roles.position ASC")
  }, through: :songs_artist_roles, source: :artist_name

  has_many :vocalists, -> {
    select("DISTINCT ON (artist_names.id) artist_names.*, songs_artist_roles.position")
    .joins(:songs_artist_roles)
    .where(songs_artist_roles: { artist_role: ArtistRole.role_for("vocalist") })
    .order("artist_names.id, songs_artist_roles.position ASC")
  }, through: :songs_artist_roles, source: :artist_name

  has_many :lyricists, -> {
    select("DISTINCT ON (artist_names.id) artist_names.*, songs_artist_roles.position")
    .joins(:songs_artist_roles)
    .where(songs_artist_roles: { artist_role: ArtistRole.role_for("lyricist") })
    .order("artist_names.id, songs_artist_roles.position ASC")
  }, through: :songs_artist_roles, source: :artist_name

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
