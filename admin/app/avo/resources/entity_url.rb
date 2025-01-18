class Avo::Resources::EntityUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_url"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.entity_url.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.entity_url.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.entity_url.updated_at"

    field :entity_type, as: :text,
      translation_key: "activerecord.attributes.entity_url.entity_type"

    field :entity_id, as: :text,
      translation_key: "activerecord.attributes.entity_url.entity_id"

    field :url, as: :text,
      translation_key: "activerecord.attributes.entity_url.url"

    field :description, as: :text,
      translation_key: "activerecord.attributes.entity_url.description"
  end
end
