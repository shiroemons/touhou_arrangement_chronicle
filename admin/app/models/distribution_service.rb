class DistributionService < ApplicationRecord
  # 関連
  has_many :distribution_service_urls, foreign_key: "service_name", primary_key: "service_name"

  # バリデーション
  validates :service_name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :base_urls, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
