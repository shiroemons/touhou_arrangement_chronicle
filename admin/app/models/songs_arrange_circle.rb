class SongsArrangeCircle < ApplicationRecord
  acts_as_list
  # 関連
  belongs_to :song
  belongs_to :circle

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }
end
