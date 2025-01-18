class Avo::Resources::Album < Avo::BaseResource
  self.title = :title
  self.translation_key = "activerecord.resources.album"
  self.includes = [ :release_circle, :event_day, :album_discs, :circles ]

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.album.id"
    field :created_at, as: :date_time, translation_key: "activerecord.attributes.album.created_at", hide_on: [ :index ]
    field :updated_at, as: :date_time, translation_key: "activerecord.attributes.album.updated_at", hide_on: [ :index ]

    field :name, as: :text, required: true,
      translation_key: "activerecord.attributes.album.name",
      help: "アルバム名"

    field :name_reading, as: :text,
      translation_key: "activerecord.attributes.album.name_reading",
      help: "読み方"

    field :slug, as: :text, required: true,
      translation_key: "activerecord.attributes.album.slug",
      help: "識別用スラッグ"

    field :release_circle, as: :belongs_to,
      translation_key: "activerecord.attributes.album.release_circle",
      name: "頒布サークル"

    field :release_circle_name, as: :text,
      translation_key: "activerecord.attributes.album.release_circle_name",
      help: "頒布主体サークル名（テキストで記録）"

    field :release_date, as: :date,
      translation_key: "activerecord.attributes.album.release_date",
      help: "頒布日"

    field :release_year, as: :number,
      translation_key: "activerecord.attributes.album.release_year",
      help: "頒布年"

    field :release_month, as: :number,
      translation_key: "activerecord.attributes.album.release_month",
      help: "頒布月"

    field :event_day, as: :belongs_to,
      translation_key: "activerecord.attributes.album.event_day",
      help: "頒布イベント日程"

    field :album_number, as: :text,
      translation_key: "activerecord.attributes.album.album_number",
      help: "アルバムカタログ番号等"

    field :credit, as: :trix,
      translation_key: "activerecord.attributes.album.credit",
      help: "クレジット情報"

    field :introduction, as: :trix,
      translation_key: "activerecord.attributes.album.introduction",
      help: "短い紹介文"

    field :description, as: :trix,
      translation_key: "activerecord.attributes.album.description",
      help: "詳細説明"

    field :note, as: :textarea,
      translation_key: "activerecord.attributes.album.note",
      help: "メモ"

    field :url, as: :text,
      translation_key: "activerecord.attributes.album.url",
      help: "アルバム公式URL"

    field :published_at, as: :date_time,
      translation_key: "activerecord.attributes.album.published_at"

    field :archived_at, as: :date_time,
      translation_key: "activerecord.attributes.album.archived_at"

    field :position, as: :number,
      translation_key: "activerecord.attributes.album.position",
      help: "表示順序"

    # 関連
    field :album_discs, as: :has_many,
      translation_key: "activerecord.attributes.album.album_discs"

    field :circles, as: :has_many,
      translation_key: "activerecord.attributes.album.circles",
      through: :albums_circles

    field :songs, as: :has_many,
      translation_key: "activerecord.attributes.album.songs"
  end
end
