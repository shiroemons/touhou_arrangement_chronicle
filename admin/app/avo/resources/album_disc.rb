class Avo::Resources::AlbumDisc < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.album_disc"
  self.includes = [ :album ]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

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

  def search_query
    query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end
end
