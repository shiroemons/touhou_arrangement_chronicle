class Avo::Resources::AlbumPrice < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_price"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.album_price.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.album_price.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.album_price.updated_at"

    field :album, as: :belongs_to,
      translation_key: "activerecord.attributes.album_price.album"

    field :shop, as: :belongs_to,
      translation_key: "activerecord.attributes.album_price.shop"

    field :price, as: :number,
      translation_key: "activerecord.attributes.album_price.price"

    field :tax_included, as: :boolean,
      translation_key: "activerecord.attributes.album_price.tax_included"

    field :currency, as: :text,
      translation_key: "activerecord.attributes.album_price.currency"

    field :position, as: :number,
      translation_key: "activerecord.attributes.album_price.position"
  end
end
