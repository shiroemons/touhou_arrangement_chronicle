class EventEdition < ApplicationRecord
  # 関連
  belongs_to :event_series
  has_many :event_days, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :display_name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true }

  # カスタムバリデーション
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, :must_be_after_start_date) if end_date < start_date
  end
end
