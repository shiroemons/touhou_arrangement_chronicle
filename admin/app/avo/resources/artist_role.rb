class Avo::Resources::ArtistRole < Avo::BaseResource
  self.title = :display_name
  self.translation_key = "activerecord.resources.artist_role"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true,
      help: "役割名(vocalist, composer等)"

    field :display_name, as: :text, required: true,
      help: "表示名(ボーカリスト, 作曲家, 編曲家等)"

    field :description, as: :trix,
      help: "役割の意味説明"

    field :note, as: :textarea

    # 関連
    field :songs_artist_roles, as: :has_many
  end
end
