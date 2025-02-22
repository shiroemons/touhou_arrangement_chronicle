class Avo::Resources::AlbumUpc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.album_upc"

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        upc_cont: params[:q],
        album_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.upc,
        description: record.album&.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :album, as: :belongs_to
    field :upc, as: :text
    field :note, as: :textarea
  end
end
