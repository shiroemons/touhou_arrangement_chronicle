class AlbumUpcResource < Avo::BaseResource
  self.title = :upc
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :album, as: :belongs_to, required: true
  field :upc, as: :text, required: true
end
