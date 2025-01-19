class Avo::Resources::AlbumUpc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_upc"

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :album, as: :belongs_to
    field :upc, as: :text
    field :note, as: :textarea
  end
end
