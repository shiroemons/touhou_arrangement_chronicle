class Artist < ApplicationRecord
  default_scope { order(name: :asc) }

  include InitialLetterable

  has_many :songs_arrangers, dependent: :destroy
  has_many :arranger_songs, through: :songs_arrangers, source: :song
  has_many :songs_composers, dependent: :destroy
  has_many :composer_songs, through: :songs_composers, source: :song
  has_many :songs_lyricists, dependent: :destroy
  has_many :lyricist_songs, through: :songs_lyricists, source: :song
  has_many :songs_rearrangers, dependent: :destroy
  has_many :rearranger_songs, through: :songs_rearrangers, source: :song
  has_many :songs_vocalists, dependent: :destroy
  has_many :vocalist_songs, through: :songs_vocalists, source: :song

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
