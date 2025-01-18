class Avo::Resources::SongBmp < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_bmp"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.song_bmp.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.song_bmp.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.song_bmp.updated_at"

    field :song, as: :belongs_to,
      translation_key: "activerecord.attributes.song_bmp.song"

    field :bmp, as: :text,
      translation_key: "activerecord.attributes.song_bmp.bmp"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.song_bmp.note"
  end
end
