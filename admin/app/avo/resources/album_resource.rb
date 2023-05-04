class AlbumResource < Avo::BaseResource
  self.title = :name
  self.includes = %i[event sub_event circles songs album_consignment_shops album_distribution_service_urls album_upcs genres tags]
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :release_circle_name, as: :text, sortable: true
  field :name, as: :text, required: true, sortable: true
  field :release_date, as: :date, sortable: true
  field :event, as: :belongs_to, searchable: true
  field :sub_event, as: :belongs_to, searchable: true, hide_on: [:index]
  field :search_enabled, as: :boolean, hide_on: [:index]
  field :album_number, as: :text, hide_on: [:index]
  field :event_price, as: :number, hide_on: [:index]
  field :currency, as: :text, hide_on: [:index]
  field :credit, as: :markdown, hide_on: [:index]
  field :introduction, as: :markdown, hide_on: [:index]
  field :url, as: :text, hide_on: [:index]

  field :circles, as: :has_many, searchable: true
  field :songs, as: :has_many, searchable: true

  tabs do
    field :album_consignment_shops, as: :has_many, searchable: true
    field :album_distribution_service_urls, as: :has_many, searchable: true
    field :album_upcs, as: :has_many, searchable: true
  end

  tabs do
    field :genres, as: :has_many, searchable: true
    field :tags, as: :has_many, searchable: true
  end

  field :complex_name, as: :text, hide_on: :all, as_label: true do |model|
    "[#{model.release_circle_name}] #{model.name}"
  end
end
