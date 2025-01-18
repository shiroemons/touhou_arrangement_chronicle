class Avo::Resources::DistributionServiceUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.distribution_service_url"

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.distribution_service_url.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.distribution_service_url.created_at"
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.distribution_service_url.updated_at"

    field :distribution_service, as: :belongs_to,
      translation_key: "activerecord.attributes.distribution_service_url.distribution_service"

    field :url, as: :text,
      translation_key: "activerecord.attributes.distribution_service_url.url"

    field :description, as: :text,
      translation_key: "activerecord.attributes.distribution_service_url.description"
  end
end
