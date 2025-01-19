class Avo::Resources::AlbumsCircle < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.albums_circle"
  self.ordering = {
    display_inline: true,
    visible_on: :index,
    actions: {
      higher: -> { record.move_higher },
      lower: -> { record.move_lower },
      to_top: -> { record.move_to_top },
      to_bottom: -> { record.move_to_bottom }
    }
  }

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
