class Avo::Resources::ArtistName < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.artist_name"
  self.includes = [ :artist ]

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        name_cont: params[:q],
        name_reading_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.name,
        description: record.artist&.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :artist, as: :belongs_to, required: true

    field :name, as: :text, required: true,
      help: "名義"

    field :name_reading, as: :text,
      help: "名義読み方"

    field :is_main_name, as: :boolean, required: true,
      help: "本名義フラグ"

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
      help: "名義に関する説明文"

    field :note, as: :textarea

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    # 関連
    field :tags, as: :has_many, through: :taggings, sortable: true, name: "タグ"
    field :genres, as: :has_many, through: :genreable_genres, sortable: true, name: "ジャンル"
    field :reference_urls, as: :has_many, through: :reference_urls, name: "リファレンスURL"
  end
end
