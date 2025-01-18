class EventSeries < ApplicationRecord
  # 関連
  has_many :event_editions, dependent: :restrict_with_error

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
