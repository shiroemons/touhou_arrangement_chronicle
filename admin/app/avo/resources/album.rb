class Avo::Resources::Album < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.album"
  self.includes = [ :release_circle, :event_day, :album_discs, :circles ]
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
        name_reading_cont: params[:q],
        release_circle_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: "#{record.name}",
        description: record.release_circle.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :name, as: :text, required: true
    field :name_reading, as: :text
    field :slug, as: :text, required: true, help: "識別用スラッグ"
    field :release_circle, as: :belongs_to, name: "頒布サークル"
    field :release_circle_name, as: :text, help: "頒布主体サークル名（テキストで記録）"
    field :release_date, as: :date, help: "頒布日"
    field :release_year, as: :number, help: "頒布年"
    field :release_month, as: :number, help: "頒布月"
    field :event_day, as: :belongs_to, help: "頒布イベント日程"
    field :album_number, as: :text, help: "アルバムカタログ番号等"
    field :credit, as: :trix, help: "クレジット情報"
    field :introduction, as: :trix, help: "短い紹介文"
    field :description, as: :trix, help: "詳細説明"
    field :note, as: :textarea
    field :url, as: :text,      help: "アルバム公式URL"
    field :published_at, as: :date_time
    field :archived_at, as: :date_time
    field :position, as: :number

    # 関連
    field :album_discs, as: :has_many, name: "ディスク"
    field :circles, as: :has_many, through: :albums_circles, name: "サークル"
    field :songs, as: :has_many, name: "楽曲"
    field :streamable_urls, as: :has_many, name: "ストリームURL"
    field :tags, as: :has_many, through: :taggings, name: "タグ"
    field :genres, as: :has_many, through: :genreable_genres, name: "ジャンル"
    field :reference_urls, as: :has_many, name: "リファレンスURL"
  end
end
