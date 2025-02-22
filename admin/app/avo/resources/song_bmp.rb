class Avo::Resources::SongBmp < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.song_bmp"

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        bpm_eq: params[:q],
        song_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "BPM: #{record.bpm}",
        description: "#{record.song&.name} (#{record.start_time_ms}ms ~ #{record.end_time_ms}ms)"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :song, as: :belongs_to
    field :bmp, as: :text
    field :note, as: :textarea
  end
end
