class Avo::Resources::EventSeries < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.event_series"
  self.includes = [ :event_editions ]
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

    field :name, as: :text, required: true,
      help: "システム管理名(内部名)"

    field :display_name, as: :text, required: true,
      help: "ユーザー向け表示名"

    field :slug, as: :text, required: true,
      help: "外部公開用の簡易識別子"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    field :position, as: :number

    # 関連
    field :event_editions, as: :has_many
  end
end
