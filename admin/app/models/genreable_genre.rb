class GenreableGenre < ApplicationRecord
  # 関連
  belongs_to :genre
  belongs_to :genreable, polymorphic: true

  acts_as_list scope: [ :genreable_type, :genreable_id ]

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
