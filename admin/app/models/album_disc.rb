class AlbumDisc < ApplicationRecord
  # 関連
  belongs_to :album
  has_many :songs

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }
end
