class Avo::Resources::EventDay < Avo::BaseResource
  self.title = :date
  self.translation_key = "activerecord.resources.event_day"
  self.includes = [:event_edition]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [:index]
    field :updated_at, as: :date_time, hide_on: [:index]

    field :event_edition, as: :belongs_to, required: true
    
    field :day_number, as: :number,
      help: "イベント中の何日目か（1日目=1,2日目=2など）"
    
    field :display_name, as: :text,
      help: "日程表示名（1日目、Day 1など）"
    
    field :event_date, as: :date,
      help: "実際の開催日付"
    
    field :region_code, as: :text, required: true,
      default: "JP",
      help: "開催地域コード"
    
    field :is_cancelled, as: :boolean, required: true,
      help: "中止フラグ"
    
    field :is_online, as: :boolean, required: true,
      help: "オンライン開催フラグ"
    
    field :description, as: :trix,
      help: "日ごとの説明"
    
    field :note, as: :textarea,
      help: "メモ"

    field :published_at, as: :date_time
    field :archived_at, as: :date_time
    
    field :position, as: :number,
      help: "表示順序"

    # 関連
    field :albums, as: :has_many
  end
end
