class ArtistResource < Avo::BaseResource
  self.title = :name
  self.includes = %i[arranger_songs rearranger_songs lyricist_songs vocalist_songs composer_songs]
  self.search_query = lambda {
    scope.ransack(name_cont: params[:q], m: "or").result(distinct: false)
  }

  field :id, as: :id, link_to_resource: true
  field :name, as: :text, required: true, sortable: true
  field :name_reading, as: :text, sortable: true
  field :slug, as: :text, required: true
  field :description, as: :markdown, hide_on: [:index]

  field :initial_letter_type, as: :badge, options: { info: %w[symbol number other], success: %w[hiragana katakana], warning: %w[kanji], danger: %w[alphabet] }, show_on: [:index]
  field :initial_letter_detail, as: :badge, show_on: [:index]

  panel name: 'URLs' do
    field :url, as: :text, hide_on: [:index]
    field :blog_url, as: :text, hide_on: [:index]
    field :twitter_url, as: :text, hide_on: [:index]
    field :youtube_channel_url, as: :text, hide_on: [:index]
  end

  tabs do
    field :arranger_songs, as: :has_many, through: :songs_arrangers, searchable: true, show_on: :edit
    field :lyricist_songs, as: :has_many, through: :songs_lyricists, searchable: true, show_on: :edit
    field :vocalist_songs, as: :has_many, through: :songs_vocalists, searchable: true, show_on: :edit
    field :rearranger_songs, as: :has_many, through: :songs_rearrangers, searchable: true, show_on: :edit
    field :composer_songs, as: :has_many, through: :songs_composers, searchable: true, show_on: :edit
  end
end
