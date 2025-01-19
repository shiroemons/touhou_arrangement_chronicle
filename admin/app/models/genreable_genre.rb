class GenreableGenre < ApplicationRecord
  # 関連
  belongs_to :genre
  belongs_to :genreable, polymorphic: true
end
