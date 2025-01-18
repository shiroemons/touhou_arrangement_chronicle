class Avo::Resources::Shop < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.shop"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

    field :name, as: :text, required: true,
      help: "内部システムで用いるショップの識別名(ユニーク)"

    field :display_name, as: :text, required: true,
      help: "表示用のショップ名"

    field :description, as: :trix,
      help: "ショップの説明"

    field :note, as: :textarea,
      help: "備考"

    field :website_url, as: :text,
      help: "公式サイトURL"

    field :base_urls, as: :code,
      language: "json",
      help: "このショップに関連するベースURLリスト(json形式)"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    field :position, as: :number,
      help: "表示順序"

    # 関連
    field :album_prices, as: :has_many
  end
end
