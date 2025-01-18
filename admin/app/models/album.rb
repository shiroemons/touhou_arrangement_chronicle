class Album < ApplicationRecord
  # 関連
  has_many :album_discs, dependent: :destroy
  has_many :album_prices, dependent: :destroy
  has_many :album_upcs, dependent: :destroy
  has_many :albums_circles, dependent: :destroy
  has_many :circles, through: :albums_circles
  has_many :songs, dependent: :restrict_with_error
  belongs_to :release_circle, class_name: "Circle", optional: true
  belongs_to :event_day, optional: true
  has_many :entity_genres, as: :entity
  has_many :entity_tags, as: :entity
  has_many :distribution_service_urls, as: :entity

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
