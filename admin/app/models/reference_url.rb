class ReferenceUrl < ApplicationRecord
  belongs_to :referenceable, polymorphic: true

  validates :url, presence: true, url: true
  validates :url_type, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :referenceable_type, presence: true, inclusion: { in: %w[ArtistName Circle Album Song] }
end
