class EventResource < Avo::BaseResource
  self.title = :name
  self.includes = [:event_series]
  self.search_query = -> do
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, link_to_resource: true
  field :event_series, as: :belongs_to, searchable: true
  field :name, as: :text, required: true, sortable: true
  field :display_name, as: :text, required: true, sortable: true
  field :event_dates, as: :text
  field :event_status, as: :badge
  field :format, as: :badge
  field :region_code, as: :country, required: true, display_code: true
  field :address, as: :text, hide_on: [:index]
  field :description, as: :markdown, hide_on: [:index]
  field :url, as: :text, hide_on: [:index]
  field :twitter_url, as: :text, hide_on: [:index]

  field :albums, as: :has_many, searchable: true

  field :complex_name, as: :text, hide_on: :all, as_label: true do |model|
    "[#{model.event_series.name}] #{model.name}"
  end
end
