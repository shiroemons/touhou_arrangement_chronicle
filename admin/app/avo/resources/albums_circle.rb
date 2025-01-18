class Avo::Resources::AlbumsCircle < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.albums_circle"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.albums_circle.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.albums_circle.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.albums_circle.updated_at"

    field :album, as: :belongs_to,
      translation_key: "activerecord.attributes.albums_circle.album"

    field :circle, as: :belongs_to,
      translation_key: "activerecord.attributes.albums_circle.circle"

    field :role, as: :text,
      translation_key: "activerecord.attributes.albums_circle.role"

    field :position, as: :number,
      translation_key: "activerecord.attributes.albums_circle.position"
  end
end
