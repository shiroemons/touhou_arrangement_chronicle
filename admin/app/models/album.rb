class Album < ApplicationRecord
  has_many :albums_circles, dependent: :destroy
  has_many :circles, through: :albums_circles
  has_many :albums_genres, dependent: :destroy
  has_many :genres, through: :albums_genres
  has_many :albums_tags, dependent: :destroy
  has_many :tags, through: :albums_tags

  has_many :songs, -> { order(Arel.sql('songs.track_number ASC')) }, dependent: :destroy
  has_many :album_consignment_shops, dependent: :destroy
  has_many :album_distribution_service_urls, dependent: :destroy
  has_many :album_upcs, dependent: :destroy

  belongs_to :event
  belongs_to :sub_event

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
