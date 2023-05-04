class EventSeriesResource < Avo::BaseResource
  self.title = :display_name
  self.includes = []
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :name, as: :text, required: true
  field :display_name, as: :text, required: true

  field :events, as: :has_many
end
