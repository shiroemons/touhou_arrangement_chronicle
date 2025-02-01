class SongsArtistRole < ApplicationRecord
  acts_as_list
  # 関連
  belongs_to :song
  belongs_to :artist_name
  belongs_to :artist_role

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }
end
