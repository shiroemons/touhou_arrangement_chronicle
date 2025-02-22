class Avo::Resources::AlbumDisc < Avo::BaseResource
  self.title = :album_disc_name
  self.translation_key = "activerecord.resources.album_disc"
  self.includes = [ :album ]
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
        name_cont: params[:q],
        album_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.name || "Disc #{record.disc_number}",
        description: "Album: #{record.album&.name}"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # アルバムとの関連
    field :album, as: :belongs_to

    # 基本情報
    field :disc_number, as: :number,
      help: "ディスクの通し番号（1枚目=1、2枚目=2など）"

    field :name, as: :text,
      help: "ディスク名（必要な場合）"

    field :description, as: :textarea,
      help: "ディスクに関する説明（例: ボーナスディスクの詳細など）"

    field :note, as: :textarea,
      help: "備考"

    field :position, as: :number,
      help: "表示順序"
  end
end
