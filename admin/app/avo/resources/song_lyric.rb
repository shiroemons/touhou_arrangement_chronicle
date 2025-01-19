class Avo::Resources::SongLyric < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_lyric"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :language, as: :text
    field :text, as: :trix
    field :note, as: :textarea
  end
end
