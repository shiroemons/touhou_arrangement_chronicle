class Avo::Resources::SongIsrc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_isrc"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.song_isrc.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.song_isrc.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.song_isrc.updated_at"

    field :song, as: :belongs_to,
      translation_key: "activerecord.attributes.song_isrc.song"

    field :isrc, as: :text,
      translation_key: "activerecord.attributes.song_isrc.isrc"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.song_isrc.note"
  end
end
