class Circle < ApplicationRecord
  default_scope { order(name: :asc) }

  include InitialLetterable

  has_many :albums_circles, dependent: :destroy
  has_many :albums, through: :albums_circles
  has_many :circles_genres, dependent: :destroy
  has_many :genres, through: :circles_genres
  has_many :circles_tags, dependent: :destroy
  has_many :tags, through: :circles_tags

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end
end
