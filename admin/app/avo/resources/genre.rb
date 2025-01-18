class Avo::Resources::Genre < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.genre"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [:index]
    field :updated_at, as: :date_time, hide_on: [:index]

    field :name, as: :text, required: true,
      help: "ジャンル名（ユニーク）"
    
    field :description, as: :trix,
      help: "ジャンルの簡易説明"
    
    field :note, as: :textarea,
      help: "ジャンルに関する補足情報"

    # 関連
    field :songs, as: :has_many, through: :songs_genres
    field :albums, as: :has_many, through: :entity_genres, polymorphic_as: :album
    field :circles, as: :has_many, through: :entity_genres, polymorphic_as: :circle
    field :artists, as: :has_many, through: :entity_genres, polymorphic_as: :artist
  end
end
