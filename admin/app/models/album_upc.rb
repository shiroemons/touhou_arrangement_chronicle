class AlbumUpc < ApplicationRecord
  acts_as_list scope: :album

  # 関連
  belongs_to :album

  # バリデーション
  validates :upc, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
