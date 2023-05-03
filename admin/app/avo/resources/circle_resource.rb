class CircleResource < Avo::BaseResource
  self.title = :name
  self.includes = [:albums, :genres, :tags]
  self.search_query = -> do
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, link_to_resource: true
  field :name, as: :text, required: true, sortable: true
  field :name_reading, as: :text, sortable: true
  field :description, as: :markdown, hide_on: [:index]

  field :initial_letter_type, as: :badge
  field :initial_letter_detail, as: :badge

  panel name: 'URLs' do
    field :url, as: :text, hide_on: [:index]
    field :blog_url, as: :text, hide_on: [:index]
    field :twitter_url, as: :text, hide_on: [:index]
    field :youtube_channel_url, as: :text, hide_on: [:index]
  end

  field :albums, as: :has_many, searchable: true

  tabs do
    field :genres, as: :has_many, searchable: true
    field :tags, as: :has_many, searchable: true
  end
end
