class Song < ApplicationRecord
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
  has_many :original_songs, -> { order(position: :asc) }, through: :songs_original_songs
  has_many :songs_artist_roles, dependent: :destroy
  has_many :artist_names, through: :songs_artist_roles
  has_many :artist_roles, through: :songs_artist_roles
  has_many :songs_genres, dependent: :destroy
  has_many :genres, -> { order(position: :asc) }, through: :songs_genres
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, -> { order(position: :asc) }, through: :taggings
  has_many :streamable_urls, -> { order(position: :asc) }, as: :streamable, dependent: :destroy

  acts_as_list scope: :arrange_circles
  acts_as_list scope: :original_songs
  acts_as_list scope: :genres
  acts_as_list scope: :streamable_urls

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
