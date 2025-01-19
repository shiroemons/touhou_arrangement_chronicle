class Circle < ApplicationRecord
  include FirstCharacterAnalyzable

  # 関連
  has_many :albums_circles
  has_many :albums, through: :albums_circles
  has_many :songs_arrange_circles
  has_many :songs, through: :songs_arrange_circles
  has_many :entity_urls, as: :entity
  has_many :entity_genres, as: :entity
  has_many :entity_tags, as: :entity

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
