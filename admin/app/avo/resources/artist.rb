class Avo::Resources::Artist < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.artist"
  self.includes = [ :artist_names ]

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.artist.id"
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

    field :name, as: :text, required: true,
      translation_key: "activerecord.attributes.artist.name",
      help: "開発・管理用の内部名"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.artist.note",
      help: "補足情報"

    # 関連
    field :artist_names, as: :has_many
  end
end
