class Avo::Resources::SongsGenre < Avo::BaseResource
  self.title = :id
  self.includes = [ :song, :genre ]
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

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        song_name_cont: params[:q],
        genre_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.song&.name} - #{record.genre&.name}",
        description: record.song&.name_reading
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :song, as: :belongs_to
    field :genre, as: :belongs_to

    # 時間範囲
    field :start_time_ms, as: :number,
          help: "このジャンルが適用される楽曲内の開始時刻(ミリ秒)"
    field :end_time_ms, as: :number,
          help: "このジャンルが適用される楽曲内の終了時刻(ミリ秒)"

    # ロック日時
    field :locked_at, as: :date_time,
          help: "ジャンル情報を固定する日時（再編集不可などの運用制約に使用）"

    # 順序
    field :position, as: :number
  end
end
