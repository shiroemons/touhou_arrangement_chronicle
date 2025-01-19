class Avo::Resources::Song < Avo::BaseResource
  self.title = :title
  self.translation_key = "activerecord.resources.song"
  self.includes = [ :circle, :album, :album_disc, :original_songs ]
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

    field :circle, as: :belongs_to
    field :album, as: :belongs_to

    field :name, as: :text, required: true,
      help: "楽曲名（正式タイトル）"

    field :name_reading, as: :text,
      help: "名前読み方"

    field :release_date, as: :date,
      help: "頒布日"

    field :release_year, as: :number,
      help: "頒布年"

    field :release_month, as: :number,
      help: "頒布月"

    field :slug, as: :text, required: true,
      help: "識別用スラッグ"

    field :album_disc, as: :belongs_to
    field :disc_number, as: :number
    field :track_number, as: :number,
      help: "トラック番号"

    field :length_time_ms, as: :number,
      help: "曲の長さ(ミリ秒)"

    field :bpm, as: :number,
      help: "BPM"

    field :description, as: :trix,
      help: "楽曲に関する説明文"

    field :note, as: :textarea,
      help: "メモ"

    # 表示用フィールド
    field :display_composer, as: :text
    field :display_arranger, as: :text
    field :display_rearranger, as: :text
    field :display_lyricist, as: :text
    field :display_vocalist, as: :text
    field :display_original_song, as: :text

    field :published_at, as: :date_time
    field :archived_at, as: :date_time

    field :position, as: :number

    # 関連
    field :original_songs, as: :has_many, through: :songs_original_songs
    field :arrange_circles, as: :has_many, through: :songs_arrange_circles
    field :lyrics, as: :has_many, class_name: "SongLyric"
    field :bmps, as: :has_many, class_name: "SongBmp"
    field :isrcs, as: :has_many, class_name: "SongIsrc"
    field :tags, as: :has_many, through: :taggings
    field :genres, as: :has_many, through: :genreable_genres
    field :streamable_urls, as: :has_many, through: :streamable_urls
    field :reference_urls, as: :has_many, through: :reference_urls
  end
end
