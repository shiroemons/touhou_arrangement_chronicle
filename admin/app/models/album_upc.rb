class AlbumUpc < ApplicationRecord
  # 関連
  belongs_to :album

  # バリデーション
  validates :upc, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
