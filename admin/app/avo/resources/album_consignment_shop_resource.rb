class AlbumConsignmentShopResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :album, as: :belongs_to, required: true
  field :shop, as: :text, required: true
  field :url, as: :text, required: true
  field :tax_included, as: :text, required: true
  field :shop_price, as: :number, required: true
  field :currency, as: :text, required: true
end
