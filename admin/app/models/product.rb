class Product < ApplicationRecord
  default_scope { order(id: :asc) }

  has_many :product_distribution_service_urls, dependent: :destroy
  has_many :original_songs, -> { order(Arel.sql('original_songs.track_number ASC')) }, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
