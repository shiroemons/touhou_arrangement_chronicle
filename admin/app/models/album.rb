class Album < ApplicationRecord
  belongs_to :release_circle, class_name: "Circle", optional: true
  belongs_to :event_day, optional: true
  has_many :album_discs, -> { order(position: :asc) }, dependent: :destroy
  has_many :album_prices, -> { order(position: :asc) }, dependent: :destroy
  has_many :album_upcs, dependent: :destroy
  has_many :albums_circles, -> { order(position: :asc) }, dependent: :destroy
  has_many :circles, through: :albums_circles
  has_many :songs, -> { order(position: :asc) }, dependent: :restrict_with_error
  has_many :genreable_genres, as: :genreable, dependent: :destroy
  has_many :genres, -> { order(position: :asc) }, through: :genreable_genres
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, -> { order(position: :asc) }, through: :taggings
  has_many :reference_urls, -> { order(position: :asc) }, as: :referenceable, dependent: :destroy
  has_many :streamable_urls, -> { order(position: :asc) }, as: :streamable, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
