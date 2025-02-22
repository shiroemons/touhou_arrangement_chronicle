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

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        album_name_cont: params[:q],
        circle_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.album&.name} - #{record.circle&.name}",
        description: record.album&.name_reading
      }
    end
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
