class Avo::Resources::ReferenceUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.reference_url"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :referenceable,
          as: :belongs_to,
          polymorphic_as: :referenceable,
          types: [ ::Album, ::Song, ::ArtistName, ::Circle ]
    field :url, as: :text
    field :description, as: :text
  end
end
