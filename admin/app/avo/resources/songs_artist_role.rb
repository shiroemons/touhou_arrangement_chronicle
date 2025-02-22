class Avo::Resources::SongsArtistRole < Avo::BaseResource
  self.title = :id
  self.includes = [ :song, :artist_name, :artist_role ]
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
        artist_name_name_cont: params[:q],
        artist_role_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.artist_name&.name} (#{record.artist_role&.display_name})",
        description: "#{record.song&.name} #{record.connector}"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :song, as: :belongs_to
    field :artist_name, as: :belongs_to
    field :artist_role, as: :belongs_to

    # 接続詞
    field :connector, as: :text,
          help: "アーティスト名と結合するための接続詞（例: vs, feat.）"

    # 順序
    field :position, as: :number
  end
end
