class Avo::Resources::EventEdition < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.event_edition"
  self.includes = [ :event_series, :event_days ]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

    field :event_series, as: :belongs_to, required: true

    field :name, as: :text, required: true,
      help: "開催回内部名"

    field :display_name, as: :text, required: true,
      help: "ユーザー表示名（例: コミックマーケット104）"

    field :slug, as: :text, required: true,
      help: "識別用スラッグ"

    field :start_date, as: :date,
      help: "開催開始日"

    field :end_date, as: :date,
      help: "開催終了日"

    field :description, as: :trix,
      help: "この開催回に関する説明"

    field :note, as: :textarea

    field :url, as: :text,
      help: "イベント公式URL"

    field :twitter_url, as: :text,
      help: "イベント公式Twitter URL"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    field :position, as: :number

    # 関連
    field :event_days, as: :has_many
  end
end
