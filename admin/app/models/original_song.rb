class OriginalSong < ApplicationRecord
  # 関連
  belongs_to :product
  belongs_to :origin_original_song, class_name: "OriginalSong", optional: true
  has_many :derived_original_songs, class_name: "OriginalSong", foreign_key: "origin_original_song_id"
  has_many :songs_original_songs
  has_many :songs, through: :songs_original_songs
  has_many :distribution_service_urls, as: :distributable, dependent: :destroy

  # バリデーション
  validates :id, presence: true
  validates :name, presence: true
  validates :track_number, presence: true, numericality: { only_integer: true }
  validates :is_original, inclusion: { in: [ true, false ] }

  def is_touhou_arrangement?
    ![ "オリジナル", "その他" ].include?(name)
  end
end
