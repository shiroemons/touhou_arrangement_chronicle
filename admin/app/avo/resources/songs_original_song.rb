class Avo::Resources::SongsOriginalSong < Avo::BaseResource
  self.title = :id
  self.includes = [ :song, :original_song ]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :song, as: :belongs_to
    field :original_song, as: :belongs_to

    # 順序
    field :position, as: :number
  end
end
