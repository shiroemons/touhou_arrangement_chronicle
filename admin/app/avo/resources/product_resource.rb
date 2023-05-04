class ProductResource < Avo::BaseResource
  self.record_selector = false
  self.title = :name
  self.includes = %i[original_songs product_distribution_service_urls]
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :name, as: :text
  field :short_name, as: :text
  field :product_type, as: :badge
  field :series_number, as: :number

  field :original_songs, as: :has_many
  field :product_distribution_service_urls, as: :has_many
end
