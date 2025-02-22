class Avo::Resources::StreamableUrl < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.streamable_url"
  self.includes = [ :distribution_service ]
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

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        url_cont: params[:q],
        streamable_type_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.url,
        description: "#{record.streamable_type}: #{record.streamable&.name}"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :streamable,
          as: :belongs_to,
          searchable: true,
          polymorphic_as: :streamable,
          types: [ ::Product, ::OriginalSong, ::Album, ::Song ]
    field :distribution_service,
          as: :belongs_to,
          searchable: true,
          foreign_key: :service_name
    field :url, as: :text
    field :description, as: :text
  end
end
