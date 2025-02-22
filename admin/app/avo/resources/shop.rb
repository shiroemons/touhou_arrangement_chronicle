class Avo::Resources::Shop < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.shop"
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

  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        name_cont: params[:q],
        display_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.display_name,
        description: record.name
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

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
    field :position, as: :number
  end
end
