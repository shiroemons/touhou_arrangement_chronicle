class Avo::Resources::EntityGenre < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_genre"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :entity_type, as: :text,
      help: "エンティティ種別"

    field :entity_id, as: :text,
      help: "エンティティID"

      field :genre, as: :belongs_to
    field :locked_at, as: :date_time
    field :position, as: :number,
      help: "表示順序"
  end
end
