class SongsGenre < ApplicationRecord
  belongs_to :song
  belongs_to :genre
end
