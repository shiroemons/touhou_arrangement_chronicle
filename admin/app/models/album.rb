class Album < ApplicationRecord
  # 関連
  has_many :album_discs, -> { order(position: :asc) }, dependent: :destroy
  has_many :album_prices, -> { order(position: :asc) }, dependent: :destroy
  has_many :album_upcs, dependent: :destroy
  has_many :albums_circles, -> { order(position: :asc) }, dependent: :destroy
  has_many :circles, through: :albums_circles
  has_many :songs, -> { order(position: :asc) }, dependent: :restrict_with_error
  belongs_to :release_circle, class_name: "Circle", optional: true
  belongs_to :event_day, optional: true
  has_many :entity_genres, -> { order(position: :asc) }, as: :entity
  has_many :entity_tags, -> { order(position: :asc) }, as: :entity
  has_many :distribution_service_urls, -> { order(position: :asc) }, as: :entity

  acts_as_list scope: :album_discs
  acts_as_list scope: :album_prices
  acts_as_list scope: :albums_circles
  acts_as_list scope: :songs
  acts_as_list scope: :entity_genres
  acts_as_list scope: :entity_tags
  acts_as_list scope: :distribution_service_urls

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
