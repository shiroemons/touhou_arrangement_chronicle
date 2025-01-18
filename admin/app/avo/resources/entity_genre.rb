class Avo::Resources::EntityGenre < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_genre"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.entity_genre.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.entity_genre.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.entity_genre.updated_at"

    field :entity_type, as: :text,
      translation_key: "activerecord.attributes.entity_genre.entity_type",
      help: "エンティティ種別"

    field :entity_id, as: :text,
      translation_key: "activerecord.attributes.entity_genre.entity_id",
      help: "エンティティID"

    field :genre, as: :belongs_to,
      translation_key: "activerecord.attributes.entity_genre.genre"

    field :locked_at, as: :date_time,
      translation_key: "activerecord.attributes.entity_genre.locked_at"

    field :position, as: :number,
      translation_key: "activerecord.attributes.entity_genre.position",
      help: "表示順序"
  end
end
