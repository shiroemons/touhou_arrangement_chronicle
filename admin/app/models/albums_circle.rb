class AlbumsCircle < ApplicationRecord
  acts_as_list scope: :album
  # 関連
  belongs_to :album
  belongs_to :circle

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }
end
