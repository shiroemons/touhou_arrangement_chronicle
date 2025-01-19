class Avo::Resources::Product < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.product"
  self.includes = [ :original_songs ]

  def fields
    field :id, as: :text
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :name, as: :text, required: true,
      help: "原作作品名（例: 東方紅魔郷）"

    field :name_reading, as: :text,
      help: "作品名の読み仮名"

    field :short_name, as: :text, required: true,
      help: "短縮名（略称）"

    field :product_type, as: :select, required: true,
      options: {
        "PC-98作品" => "pc98",
        "Windows作品" => "windows",
        "ZUN's Music Collection" => "zuns_music_collection",
        "幺樂団の歴史　～ Akyu's Untouched Score" => "akyus_untouched_score",
        "商業書籍" => "commercial_books",
        "その他" => "other"
      },
      help: "作品タイプ"

    field :series_number, as: :number, required: true,
      help: "シリーズ中での作品番号（例: 6.00 = 東方紅魔郷）"

    # 関連
    field :original_songs, as: :has_many
  end
end
