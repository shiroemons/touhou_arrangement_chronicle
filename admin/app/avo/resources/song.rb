class Avo::Resources::Song < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.song"
  self.includes = [ :circle, :album, :album_disc, :original_songs, :arrangers, :composers, :lyricists, :vocalists ]
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
        name_reading_cont: params[:q],
        slug_cont: params[:q],
        album_name_cont: params[:q],
        circle_name_cont: params[:q],
        m: "or"
      ).result(distinct: false)
    },
    item: -> do
      {
        title: record.name,
        description: [
          record.album&.name,
          record.circle&.name
        ].compact.join(" / ")
      }
    end
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
    field :original_songs, as: :has_many, through: :songs_original_songs, name: "原曲"
    # field :arrange_circles, as: :has_many, through: :songs_arrange_circles, name: "編曲サークル"
    # field :lyrics, as: :has_many, class_name: "SongLyric", name: "歌詞"
    # field :bmps, as: :has_many, class_name: "SongBmp", name: "BPM"
    # field :isrcs, as: :has_many, class_name: "SongIsrc"
    field :tags, as: :has_many, through: :taggings, name: "タグ"
    field :taggings, as: :has_many, name: "タギング"
    field :genres, as: :has_many, through: :genreable_genres, name: "ジャンル"
    # field :genreable_genres, as: :has_many, name: "ジャンラブル"
    field :streamable_urls, as: :has_many, name: "ストリームURL"
    field :reference_urls, as: :has_many, name: "リファレンスURL"
  end
end
