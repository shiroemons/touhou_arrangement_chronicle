class Artist < ApplicationRecord
  # 関連
  has_many :artist_names, dependent: :destroy
  has_one :main_name, -> { where(is_main_name: true) }, class_name: "ArtistName"

  # バリデーション
  validates :name, presence: true
end
