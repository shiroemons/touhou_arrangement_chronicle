class SongsGenre < ApplicationRecord
  # 関連
  belongs_to :song
  belongs_to :genre

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }

  # カスタムバリデーション
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time_ms.blank? || start_time_ms.blank?
    errors.add(:end_time_ms, :must_be_after_start_time) if end_time_ms <= start_time_ms
  end
end
