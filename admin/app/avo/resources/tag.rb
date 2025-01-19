class Avo::Resources::Tag < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.tag"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true,
      help: "タグ名（ユニーク）"

    field :description, as: :trix,
      help: "タグに関する説明文"

    field :note, as: :textarea,
      help: "タグに関する補足情報"

    # 関連（ポリモーフィック）
    field :albums, as: :has_many, through: :taggings, polymorphic_as: :album
    field :songs, as: :has_many, through: :taggings, polymorphic_as: :song
    field :circles, as: :has_many, through: :taggings, polymorphic_as: :circle
    field :artist_names, as: :has_many, through: :taggings, polymorphic_as: :artist_name
  end
end
