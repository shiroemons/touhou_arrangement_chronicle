class Avo::Resources::ArtistName < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.artist_name"
  self.includes = [:artist]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [:index]
    field :updated_at, as: :date_time, hide_on: [:index]

    field :artist, as: :belongs_to, required: true
    
    field :name, as: :text, required: true,
      help: "名義"
    
    field :name_reading, as: :text,
      help: "名義読み方"
    
    field :is_main_name, as: :boolean, required: true,
      help: "本名義フラグ"

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
      help: "名義に関する説明文"
    
    field :note, as: :textarea,
      help: "メモ"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time
  end
end
