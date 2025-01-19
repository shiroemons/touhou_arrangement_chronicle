class Avo::Resources::SongIsrc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_isrc"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :isrc, as: :text
    field :note, as: :textarea
  end
end
