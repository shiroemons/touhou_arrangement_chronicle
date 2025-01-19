class Avo::Resources::AlbumPrice < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_price"

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
