class SongLyric < ApplicationRecord
  acts_as_list scope: :song
  # 関連
  belongs_to :song

  # バリデーション
  validates :content, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
