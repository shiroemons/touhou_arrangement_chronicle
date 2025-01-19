class Avo::Resources::StreamableUrl < Avo::BaseResource
  self.includes = [ :distribution_service ]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]

    # 関連
    field :streamable,
          as: :belongs_to,
          searchable: true,
          foreign_key: :streamable_type
    field :url, as: :text
    field :description, as: :text
  end
end

