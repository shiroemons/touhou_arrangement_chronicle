class Avo::Resources::SongIsrc < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_isrc"

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        isrc_cont: params[:q],
        song_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.isrc,
        description: record.song&.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :isrc, as: :text
    field :note, as: :textarea
  end
end
