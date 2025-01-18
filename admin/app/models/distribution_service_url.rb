class DistributionServiceUrl < ApplicationRecord
  # 関連
  belongs_to :distribution_service, foreign_key: "service_name", primary_key: "service_name"

  # バリデーション
  validates :entity_type, presence: true, inclusion: { in: [ "product", "original_song", "album", "song" ] }
  validates :entity_id, presence: true
  validates :service_name, presence: true
  validates :url, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
