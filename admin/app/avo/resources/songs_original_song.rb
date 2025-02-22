class Avo::Resources::SongsOriginalSong < Avo::BaseResource
  self.title = :id
  self.includes = [ :song, :original_song ]
  self.ordering = {
    display_inline: true,
    visible_on: :index,
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
        song_name_cont: params[:q],
        original_song_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.song&.name} - #{record.original_song&.name}",
        description: record.original_song&.product&.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :song, as: :belongs_to
    field :original_song, as: :belongs_to

    # 順序
    field :position, as: :number
  end
end
