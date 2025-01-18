class EventDay < ApplicationRecord
  # 関連
  belongs_to :event_edition

  # バリデーション
  validates :region_code, presence: true
  validates :is_cancelled, inclusion: { in: [ true, false ] }
  validates :is_online, inclusion: { in: [ true, false ] }
  validates :position, presence: true, numericality: { only_integer: true }
end
