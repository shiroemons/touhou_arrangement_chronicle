class Avo::Resources::SongLyric < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_lyric"

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        language_cont: params[:q],
        text_cont: params[:q],
        song_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.song&.name} (#{record.language})",
        description: record.text&.truncate(100)
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :language, as: :text
    field :text, as: :trix
    field :note, as: :textarea
  end
end
