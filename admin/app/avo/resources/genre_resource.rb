class GenreResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, link_to_resource: true
  field :name, as: :text, required: true
end
