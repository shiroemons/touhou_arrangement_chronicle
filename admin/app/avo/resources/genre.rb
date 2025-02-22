class Avo::Resources::Genre < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.genre"
  self.includes = []

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.name,
        description: "#{record.songs.count}曲"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true,
      help: "ジャンル名（ユニーク）"

    field :description, as: :trix,
      help: "ジャンルの簡易説明"

    field :note, as: :textarea,
      help: "ジャンルに関する補足情報"

    # 関連
    field :songs, as: :has_many, through: :songs_genres
    field :albums, as: :has_many, through: :genreable_genres, polymorphic_as: :album
    field :circles, as: :has_many, through: :genreable_genres, polymorphic_as: :circle
    field :artist_names, as: :has_many, through: :genreable_genres, polymorphic_as: :artist_name
  end
end
