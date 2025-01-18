class Song < ApplicationRecord
  # 関連
  belongs_to :circle, optional: true
  belongs_to :album, optional: true
  belongs_to :album_disc, optional: true
  has_many :song_lyrics, dependent: :destroy
  has_many :song_bmps, dependent: :destroy
  has_many :song_isrcs, dependent: :destroy
  has_many :songs_arrange_circles, dependent: :destroy
  has_many :arrange_circles, through: :songs_arrange_circles, source: :circle
  has_many :songs_original_songs, dependent: :destroy
  has_many :original_songs, through: :songs_original_songs
  has_many :songs_artist_roles, dependent: :destroy
  has_many :artist_names, through: :songs_artist_roles
  has_many :artist_roles, through: :songs_artist_roles
  has_many :songs_genres, dependent: :destroy
  has_many :genres, through: :songs_genres
  has_many :entity_tags, as: :entity
  has_many :distribution_service_urls, as: :entity

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
