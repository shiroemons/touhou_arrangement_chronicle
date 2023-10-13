class SongsGenreResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :song, as: :belongs_to
  field :genre, as: :belongs_to
  field :locked_at, as: :datetime
end
