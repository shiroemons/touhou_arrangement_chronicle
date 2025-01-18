class Avo::Resources::EntityTag < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_tag"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.entity_tag.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.entity_tag.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.entity_tag.updated_at"

    field :entity_type, as: :text,
      translation_key: "activerecord.attributes.entity_tag.entity_type"

    field :entity_id, as: :text,
      translation_key: "activerecord.attributes.entity_tag.entity_id"

    field :tag, as: :belongs_to,
      translation_key: "activerecord.attributes.entity_tag.tag"

    field :locked_at, as: :date_time,
      translation_key: "activerecord.attributes.entity_tag.locked_at"
  end
end
