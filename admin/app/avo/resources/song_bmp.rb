class Avo::Resources::SongBmp < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_bmp"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :bmp, as: :text
    field :note, as: :textarea
  end
end
