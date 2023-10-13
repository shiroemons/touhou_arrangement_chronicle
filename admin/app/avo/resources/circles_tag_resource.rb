class CirclesTagResource < Avo::BaseResource
  self.title = :id
  self.visible_on_sidebar = false
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :circle, as: :belongs_to
  field :tag, as: :belongs_to
  field :locked_at, as: :datetime
end
