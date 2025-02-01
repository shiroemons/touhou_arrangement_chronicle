class EventDay < ApplicationRecord
  acts_as_list scope: :event_edition
  # 関連
  belongs_to :event_edition
  has_many :albums, -> { order(position: :asc) }, dependent: :destroy

  # デリゲート
  delegate :event_series, to: :event_edition

  # バリデーション
  validates :region_code, presence: true
  validates :is_cancelled, inclusion: { in: [ true, false ] }
  validates :is_online, inclusion: { in: [ true, false ] }
  validates :position, presence: true, numericality: { only_integer: true }

  def event_edition_name
    event_edition.name
  end

  def event_full_name
    display_name.blank? ? event_edition_name : "#{event_edition_name} #{display_name}"
  end
end
