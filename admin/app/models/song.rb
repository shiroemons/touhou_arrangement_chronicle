class Song < ApplicationRecord
  default_scope { order(album_id: :desc, disc_number: :asc, track_number: :asc) }

  has_many :songs_original_songs, dependent: :destroy
  has_many :original_songs, through: :songs_original_songs
  has_many :songs_composers, dependent: :destroy
  has_many :composers, through: :songs_composers, source: :artist
  has_many :songs_arrangers, dependent: :destroy
  has_many :arrangers, through: :songs_arrangers, source: :artist
  has_many :songs_rearrangers, dependent: :destroy
  has_many :rearrangers, through: :songs_rearrangers, source: :artist
  has_many :songs_lyricists, dependent: :destroy
  has_many :lyricists, through: :songs_lyricists, source: :artist
  has_many :songs_vocalists, dependent: :destroy
  has_many :vocalists, through: :songs_vocalists, source: :artist
  has_many :songs_genres, dependent: :destroy
  has_many :genres, through: :songs_genres
  has_many :songs_tags, dependent: :destroy
  has_many :tags, through: :songs_tags
  has_many :song_isrcs, dependent: :destroy
  has_many :songs_circles, dependent: :destroy
  has_many :circles, through: :songs_circles

  belongs_to :album, optional: true
  belongs_to :circle, optional: true

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end

  def composers_name
    composers.map(&:name).join(' / ')
  end

  def arrangers_name
    arrangers.map(&:name).join(' / ')
  end

  def rearrangers_name
    rearrangers.map(&:name).join(' / ')
  end

  def lyricists_name
    lyricists.map(&:name).join(' / ')
  end

  def vocalists_name
    vocalists.map(&:name).join(' / ')
  end

  def original_songs_name
    original_songs.map(&:name).join(' / ')
  end
end
