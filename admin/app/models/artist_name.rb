class ArtistName < ApplicationRecord
  include FirstCharacterAnalyzable

  # 関連
  belongs_to :artist
  has_many :songs_artist_roles
  has_many :songs, through: :songs_artist_roles
  has_many :artist_roles, through: :songs_artist_roles
  has_many :genreable_genres, as: :genreable, dependent: :destroy
  has_many :genres, -> { order(position: :asc) }, through: :genreable_genres
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, -> { order(position: :asc) }, through: :taggings
  has_many :reference_urls, -> { order(position: :asc) }, as: :referenceable, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :is_main_name, inclusion: { in: [ true, false ] }
end
