class Avo::Resources::Tagging < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.tagging"
  self.includes = [ :tag ]
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
        tag_name_cont: params[:q],
        taggable_type_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.tag&.name,
        description: "#{record.taggable_type}: #{record.taggable&.name}"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :taggable_type, as: :select, sortable: true, hide_on: [ :new, :edit ],
      options: {
        "アルバム": "Album",
        "楽曲": "Song",
        "アーティスト名": "ArtistName",
        "サークル": "Circle"
      }
    field :taggable,
          as: :belongs_to,
          searchable: true,
          polymorphic_as: :taggable,
          types: [ ::Album, ::Song, ::ArtistName, ::Circle ]
    field :tag, as: :belongs_to
    field :locked_at, as: :date_time
    field :position, as: :number, sortable: true
  end
end
