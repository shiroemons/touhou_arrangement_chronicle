class Avo::Resources::Artist < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.artist"
  self.includes = [ :artist_names ]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true,
      translation_key: "activerecord.attributes.artist.name",
      help: "開発・管理用の内部名"

    field :note, as: :textarea

    # 関連
    field :artist_names, as: :has_many, sortable: true, name: "名義"
  end
end
