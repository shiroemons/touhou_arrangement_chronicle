class Genre < ApplicationRecord
  # 関連
  has_many :songs_genres
  has_many :songs, through: :songs_genres
  has_many :genreable_genres, dependent: :destroy
  has_many :albums, through: :genreable_genres, source: :genreable, source_type: "Album"
  has_many :circles, through: :genreable_genres, source: :genreable, source_type: "Circle"
  has_many :artist_names, through: :genreable_genres, source: :genreable, source_type: "ArtistName"

  # バリデーション
  validates :name, presence: true, uniqueness: true
end
