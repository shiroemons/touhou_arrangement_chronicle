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

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        album_name_cont: params[:q],
        shop_name_cont: params[:q],
        price_eq: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.album&.name} - #{record.shop&.name}",
        description: "#{record.price} #{record.currency}"
      }
    end
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
