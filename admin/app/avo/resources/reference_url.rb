class Avo::Resources::ReferenceUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.reference_url"
  self.ordering = {
    display_inline: true,
    visible_on: :association,
    actions: {
      higher: -> { record.move_higher },
      lower: -> { record.move_lower },
      to_top: -> { record.move_to_top },
      to_bottom: -> { record.move_to_bottom }
    }
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :referenceable,
          as: :belongs_to,
          polymorphic_as: :referenceable,
          types: [ ::Album, ::Song, ::ArtistName, ::Circle ]
    field :url_type, as: :text
    field :url, as: :text
    field :description, as: :text
  end
end
