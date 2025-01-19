class StreamableUrl < ApplicationRecord
  belongs_to :streamable, polymorphic: true
  belongs_to :distribution_service, foreign_key: :service_name, primary_key: :service_name

  validates :streamable_type, inclusion: { in: %w[Product OriginalSong Album Song] }
  validates :streamable_id, presence: true
  validates :service_name, presence: true
  validates :url, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
