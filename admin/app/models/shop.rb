class Shop < ApplicationRecord
  acts_as_list
  # 関連
  has_many :album_prices

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
