class OriginalSongResource < Avo::BaseResource
  self.record_selector = false
  self.title = :name
  self.includes = [:product, :source]
  self.search_query = -> do
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id, link_to_resource: true
  field :product, as: :belongs_to
  field :name, as: :text
  field :composer, as: :text
  field :arranger, as: :text
  field :track_number, as: :text
  field :is_original, as: :boolean
  field :source, as: :belongs_to

  field :children, as: :has_many
  field :original_song_distribution_service_urls, as: :has_many
  field :songs, as: :has_many

  field :complex_name, as: :text, hide_on: :all, as_label: true do |model|
    "[#{model.product.short_name}] #{model.name}"
  end
end
