class Avo::Resources::DistributionService < Avo::BaseResource
  self.title = :service_name
  self.translation_key = "activerecord.resources.distribution_service"
  self.includes = []
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

    field :description, as: :trix
    field :note, as: :textarea
    field :position, as: :number
  end
end
