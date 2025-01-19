class ArtistRole < ApplicationRecord
  # 関連
  has_many :songs_artist_roles
  has_many :songs, through: :songs_artist_roles
  has_many :artist_names, through: :songs_artist_roles

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
end
