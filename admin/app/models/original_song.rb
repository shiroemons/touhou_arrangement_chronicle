class OriginalSong < ApplicationRecord
  default_scope { order(id: :asc) }

  has_many :songs_original_songs, dependent: :destroy
  has_many :songs, through: :songs_original_songs
  has_many :original_song_distribution_service_urls, dependent: :destroy

  belongs_to :product

  has_many :children, class_name: "OriginalSong", foreign_key: "source_id"
  belongs_to :source, class_name: 'OriginalSong', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
