class Avo::Resources::EntityUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.entity_url"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :entity_type, as: :text
    field :entity_id, as: :text
    field :url, as: :text
    field :description, as: :text
  end
end
