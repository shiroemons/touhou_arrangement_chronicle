class AlbumDisc < ApplicationRecord
  acts_as_list scope: :album
  # 関連
  belongs_to :album
  has_many :songs

  # バリデーション
  validates :position, presence: true, numericality: { only_integer: true }

  def album_disc_name
    "#{album.name} #{disc_number}枚目"
  end
end
