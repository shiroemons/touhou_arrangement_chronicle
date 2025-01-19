class Avo::Resources::Tagging < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.tagging"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :taggable_type, as: :text
    field :taggable_id, as: :text
    field :tag, as: :belongs_to
    field :locked_at, as: :date_time
  end
end
