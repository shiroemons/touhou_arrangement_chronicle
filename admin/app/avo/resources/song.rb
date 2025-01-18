class Avo::Resources::Song < Avo::BaseResource
  self.title = :title
  self.translation_key = "activerecord.resources.song"
  self.includes = [ :circle, :album, :album_disc, :original_songs ]

  def fields
    field :id, as: :id, translation_key: "activerecord.attributes.song.id"
    field :created_at, as: :date_time, hide_on: [ :index ]
    field :updated_at, as: :date_time, hide_on: [ :index ]

    field :circle, as: :belongs_to
    field :album, as: :belongs_to

    field :name, as: :text, required: true,
      translation_key: "activerecord.attributes.song.name",
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
      translation_key: "activerecord.attributes.song.track_number",
      help: "トラック番号"

    field :length_time_ms, as: :number,
      translation_key: "activerecord.attributes.song.length",
      help: "曲の長さ(ミリ秒)"

    field :bpm, as: :number,
      translation_key: "activerecord.attributes.song.bpm",
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

    field :position, as: :number,
      help: "表示順序"

    # 関連
    field :original_songs, as: :has_many, through: :songs_original_songs
    field :arrange_circles, as: :has_many, through: :songs_arrange_circles
    field :lyrics, as: :has_many, class_name: "SongLyric"
    field :bmps, as: :has_many, class_name: "SongBmp"
    field :isrcs, as: :has_many, class_name: "SongIsrc"
  end
end
