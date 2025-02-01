class GenreableGenre < ApplicationRecord
  acts_as_list scope: [ :genreable_type, :genreable_id ]
  # 関連
  belongs_to :genre
  belongs_to :genreable, polymorphic: true

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
