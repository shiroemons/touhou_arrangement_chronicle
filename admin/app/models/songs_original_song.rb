class SongsOriginalSong < ApplicationRecord
  # 関連
  belongs_to :song
  belongs_to :original_song

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }
end
