class SongsArranger < ApplicationRecord
  belongs_to :song
  belongs_to :artist
end
