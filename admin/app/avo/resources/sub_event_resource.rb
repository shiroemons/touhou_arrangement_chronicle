class SubEventResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :event, as: :belongs_to, searchable: true
  field :name, as: :text, required: true
  field :display_name, as: :text
  field :slug, as: :text, required: true
  field :event_date, as: :date
  field :event_status, as: :select, enum: ::SubEvent.event_statuses, display_with_value: true
  field :description, as: :markdown
end
