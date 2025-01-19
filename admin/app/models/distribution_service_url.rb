class DistributionServiceUrl < ApplicationRecord
  # 関連
  belongs_to :distribution_service, foreign_key: "service_name", class_name: "DistributionService"
  belongs_to :distributable, polymorphic: true,
    foreign_key: "entity_id",
    foreign_type: "entity_type",
    primary_key: "id"

  # バリデーション
  # validates :entity_type, presence: true, inclusion: { in: [ "Product", "OriginalSong", "Album", "Song" ] }
  # validates :entity_id, presence: true
  validates :service_name, presence: true
  validates :url, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
