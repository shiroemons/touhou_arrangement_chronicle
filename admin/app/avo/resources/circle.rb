class Avo::Resources::Circle < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.circle"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

    field :name, as: :text, required: true,
      help: "サークル名"

    field :name_reading, as: :text,
      help: "読み方"

    field :slug, as: :text, required: true,
      help: "識別用スラッグ"

    field :first_character_type, as: :select, required: true,
      options: {
        "記号": :symbol,
        "数字": :number,
        "英字": :alphabet,
        "ひらがな": :hiragana,
        "カタカナ": :katakana,
        "漢字": :kanji,
        "その他": :other
      }

    field :first_character, as: :text,
      help: "頭文字詳細 (英字、ひらがな、カタカナの場合のみ)"

    field :first_character_row, as: :text,
      help: "頭文字の行 (ひらがな、カタカナの場合のみ)"

    field :description, as: :trix,
      help: "サークル説明"

    field :note, as: :textarea,
      help: "メモ"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    # 関連
    field :albums, as: :has_many, through: :albums_circles
    field :songs, as: :has_many, through: :songs_arrange_circles
  end
end
