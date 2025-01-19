class Avo::Resources::DistributionService < Avo::BaseResource
  self.title = :service_name
  self.translation_key = "activerecord.resources.distribution_service"
  self.includes = []

  # レコードの検索方法を明示的に定義
  self.find_record_method = -> {
    query.find(id)
  }

  # インデックスクエリを明示的に定義
  self.index_query = -> {
    query.all
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :service_name, as: :text, required: true,
      help: "サービス内部名（例: spotify）"

    field :display_name, as: :text, required: true,
      help: "ユーザー向け表示名（例: Spotify）"

    field :base_urls, as: :code,
      language: "json",
      help: "サービスの基本URLリスト（例: [\"https://open.spotify.com/\"]）"

    field :description, as: :trix,
      help: "サービスの説明文"

    field :note, as: :textarea,
      help: "メモや補足"

    field :position, as: :number,
      help: "表示順序"
  end
end
