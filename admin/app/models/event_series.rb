class EventSeries < ApplicationRecord
  # 関連
  has_many :event_editions, -> { order(position: :asc) }, dependent: :restrict_with_error

  acts_as_list scope: :event_editions

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }
end
