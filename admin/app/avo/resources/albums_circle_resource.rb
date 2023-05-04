class AlbumsCircleResource < Avo::BaseResource
  self.title = :album_id
  self.visible_on_sidebar = false
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :album, as: :belongs_to
  field :circle, as: :belongs_to
end
