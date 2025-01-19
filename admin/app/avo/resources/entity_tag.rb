class Avo::Resources::EntityTag < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_tag"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :entity_type, as: :text
    field :entity_id, as: :text
    field :tag, as: :belongs_to
    field :locked_at, as: :date_time
  end
end
