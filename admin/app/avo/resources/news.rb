class Avo::Resources::News < Avo::BaseResource
  self.title = :title
  self.translation_key = "activerecord.resources.news"
  self.search = {
    query: -> {
      query.ransack(
        id_eq: params[:q],
        title_cont: params[:q],
        content_cont: params[:q],
        slug_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.title,
        description: "#{I18n.t("avo.status.#{record.status}")}, #{record.category_name}"
      }
    end
  }

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    field :title, as: :text, required: true,
      name: "お知らせのタイトル"

    field :content, as: :trix, required: true,
      name: "お知らせの本文"

    field :summary, as: :textarea,
      name: "お知らせの概要（一覧表示用）"

    field :slug, as: :text, required: true,
      name: "URLフレンドリーな識別子（ユニーク）"

    field :published_at, as: :date_time, required: true,
      name: "公開日時（この日時以降に表示される）"

    field :expired_at, as: :date_time,
      name: "有効期限（この日時以降は表示されない、空の場合は無期限）"

    field :is_important, as: :boolean, default: false,
      name: "重要なお知らせかどうか（強調表示などに使用）"

    field :category, as: :select, options: News::CATEGORIES,
      name: "お知らせのカテゴリ"

    field :status, as: :badge, options: {
      upcoming: { label: I18n.t("avo.status.upcoming"), color: :warning },
      active: { label: I18n.t("avo.status.active"), color: :success },
      expired: { label: I18n.t("avo.status.expired"), color: :danger }
    }, hide_on: [ :new, :edit ]
  end
end
