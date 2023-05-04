class SongResource < Avo::BaseResource
  self.title = :name
  self.includes = %i[album genres tags]
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :album, as: :belongs_to, searchable: true
  field :name, as: :text, required: true
  field :name_reading, as: :text
  field :disc_number, as: :number, required: true
  field :track_number, as: :number, required: true
  field :release_date, as: :date
  field :search_enabled, as: :boolean, hide_on: [:index]
  field :length, as: :number, hide_on: [:index]
  field :bpm, as: :number, hide_on: [:index]
  field :display_composer, as: :text, hide_on: [:index]
  field :display_arranger, as: :text, hide_on: [:index]
  field :display_rearranger, as: :text, hide_on: [:index]
  field :display_lyricist, as: :text, hide_on: [:index]
  field :display_vocalist, as: :text, hide_on: [:index]
  field :display_original_song, as: :text, hide_on: [:index]

  field :original_songs, as: :has_many, through: :songs_original_songs, searchable: true, show_on: :edit
  tabs do
    field :composers, as: :has_many, through: :songs_composers, searchable: true, show_on: :edit
    field :arrangers, as: :has_many, through: :songs_arrangers, searchable: true, show_on: :edit
    field :rearrangers, as: :has_many, through: :songs_rearrangers, searchable: true, show_on: :edit
    field :lyricists, as: :has_many, through: :songs_lyricists, searchable: true, show_on: :edit
    field :vocalists, as: :has_many, through: :songs_vocalists, searchable: true, show_on: :edit
  end
  field :song_isrcs, as: :has_many, searchable: true, name: 'ISRCs', show_on: :edit

  tabs do
    field :genres, as: :has_many, searchable: true
    field :tags, as: :has_many, searchable: true
  end

  field :complex_name, as: :text, hide_on: :all, as_label: true do |model|
    "[#{model.album&.name}] #{model.name}"
  end
end
