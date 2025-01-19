class Avo::Resources::AlbumPrice < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_price"
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
    field :shop, as: :belongs_to
    field :price, as: :number
    field :tax_included, as: :boolean
    field :currency, as: :text
    field :position, as: :number
  end
end
