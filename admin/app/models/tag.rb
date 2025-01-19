class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :albums, through: :taggings, source: :taggable, source_type: "Album"
  has_many :songs, through: :taggings, source: :taggable, source_type: "Song"
  has_many :circles, through: :taggings, source: :taggable, source_type: "Circle"
  has_many :artist_names, through: :taggings, source: :taggable, source_type: "ArtistName"
end
