class Avo::Resources::AlbumsCircle < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.albums_circle"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :album, as: :belongs_to
    field :circle, as: :belongs_to
    field :role, as: :text
    field :position, as: :number
  end
end
