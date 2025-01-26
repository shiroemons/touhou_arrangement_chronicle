class Avo::Resources::GenreableGenre < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.genreable_genre"
  self.includes = [ :genre ]
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
    field :genreable_type, as: :select, sortable: true, hide_on: [ :new, :edit ],
      options: {
        "アルバム": "Album",
        "楽曲": "Song",
        "アーティスト名": "ArtistName",
        "サークル": "Circle"
      }
    field :genreable,
          as: :belongs_to,
          polymorphic_as: :genreable,
          types: [ ::Album, ::Song, ::ArtistName, ::Circle ]
    field :genre, as: :belongs_to
    field :locked_at, as: :date_time
    field :position, as: :number
  end
end
