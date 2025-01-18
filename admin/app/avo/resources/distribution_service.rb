class Avo::Resources::DistributionService < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.distribution_service"
  self.includes = []

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [:index]
    field :updated_at, as: :date_time, hide_on: [:index]

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

    # 関連
    field :distribution_service_urls, as: :has_many
  end
end
