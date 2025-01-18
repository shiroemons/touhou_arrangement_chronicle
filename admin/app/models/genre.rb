class Genre < ApplicationRecord
  # 関連
  has_many :songs_genres
  has_many :songs, through: :songs_genres
  has_many :entity_genres

  # バリデーション
  validates :name, presence: true, uniqueness: true
end
