class Avo::Resources::Circle < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.circle"
  self.includes = [ :albums, :songs ]

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        name_cont: params[:q],
        slug_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.name,
        description: "#{record.albums.count}個のアルバム"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true, sortable: true,
      help: "サークル名"

    field :name_reading, as: :text

    field :slug, as: :text, required: true,
      help: "識別用スラッグ"

    field :first_character_type, as: :select, sortable: true,
      hide_on: [ :new ],
      options: {
        "記号": "symbol",
        "数字": "number",
        "英字": "alphabet",
        "ひらがな": "hiragana",
        "カタカナ": "katakana",
        "漢字": "kanji",
        "その他": "other"
      }

    field :first_character, as: :text, sortable: true,
      hide_on: [ :new ],
      help: "頭文字詳細 (英字、ひらがな、カタカナの場合のみ)"

    field :first_character_row, as: :text, sortable: true,
      hide_on: [ :new ],
      help: "頭文字の行 (ひらがな、カタカナの場合のみ)"

    field :description, as: :trix,
      help: "サークル説明"

    field :note, as: :textarea

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    # 関連
    field :albums, as: :has_many, through: :albums_circles, name: "アルバム"
    field :songs, as: :has_many, through: :songs_arrange_circles, name: "楽曲"
    field :tags, as: :has_many, through: :taggings, name: "タグ"
    field :taggings, as: :has_many, name: "タギング"
    field :genres, as: :has_many, through: :genreable_genres, name: "ジャンル"
    field :genreable_genres, as: :has_many, name: "ジャンラブル"
    field :reference_urls, as: :has_many, name: "リファレンスURL"
  end
end
