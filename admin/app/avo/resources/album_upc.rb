class Avo::Resources::AlbumUpc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_upc"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.album_upc.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.album_upc.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.album_upc.updated_at"

    field :album, as: :belongs_to,
      translation_key: "activerecord.attributes.album_upc.album"

    field :upc, as: :text,
      translation_key: "activerecord.attributes.album_upc.upc"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.album_upc.note"
  end
end
