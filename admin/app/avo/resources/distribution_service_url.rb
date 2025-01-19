class Avo::Resources::DistributionServiceUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.distribution_service_url"
  self.includes = [:distribution_service]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :distribution_service,
          as: :belongs_to,
          searchable: true,
          foreign_key: :service_name,
          use_resource: "Avo::Resources::DistributionService"
    field :url, as: :text
    field :description, as: :text
  end
end
