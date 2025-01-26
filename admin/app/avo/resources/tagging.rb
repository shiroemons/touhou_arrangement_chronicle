class Avo::Resources::Tagging < Avo::BaseResource
  self.title = :id
  self.translation_key = "activerecord.resources.tagging"
  self.includes = [ :tag ]

  def fields
    field :id, as: :id
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :taggable_type, as: :select, sortable: true, hide_on: [ :new, :edit ],
      options: {
        "アルバム": "Album",
        "楽曲": "Song",
        "アーティスト名": "ArtistName",
        "サークル": "Circle"
      }
    field :taggable,
          as: :belongs_to,
          searchable: true,
          polymorphic_as: :taggable,
          types: [ ::Album, ::Song, ::ArtistName, ::Circle ]
    field :tag, as: :belongs_to
    field :locked_at, as: :date_time
  end
end
