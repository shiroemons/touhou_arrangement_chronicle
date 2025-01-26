class Circle < ApplicationRecord
  include FirstCharacterAnalyzable

  # 関連
  has_many :albums_circles
  has_many :albums, through: :albums_circles
  has_many :songs_arrange_circles
  has_many :songs, through: :songs_arrange_circles
  has_many :genreable_genres, as: :genreable, dependent: :destroy
  has_many :genres, -> { order(position: :asc) }, through: :genreable_genres
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :reference_urls, -> { order(position: :asc) }, as: :referenceable, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
