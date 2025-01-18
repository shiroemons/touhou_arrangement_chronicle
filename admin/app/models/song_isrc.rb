class SongIsrc < ApplicationRecord
  # 関連
  belongs_to :song

  # バリデーション
  validates :isrc, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
