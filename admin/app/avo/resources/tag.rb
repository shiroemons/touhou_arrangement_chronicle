class Avo::Resources::Tag < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.tag"
  self.includes = []
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
