class Avo::Resources::SongLyric < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_lyric"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.song_lyric.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.song_lyric.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.song_lyric.updated_at"

    field :song, as: :belongs_to,
      translation_key: "activerecord.attributes.song_lyric.song"

    field :language, as: :text,
      translation_key: "activerecord.attributes.song_lyric.language"

    field :text, as: :trix,
      translation_key: "activerecord.attributes.song_lyric.text"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.song_lyric.note"
  end
end
