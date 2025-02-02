module SongSearchable
  extend ActiveSupport::Concern

  included do
    include MeiliSearch::Rails

    meilisearch index_uid: "songs" do
      # 検索可能なフィールドの設定
      searchable_attributes %w[
        name
        name_reading
        album_name
        album_name_reading
        circle_name
        circles.name
        original_songs.name
        original_songs.lvl0
        original_songs.lvl1
        original_songs.lvl2
        arrangers.name
        composers.name
        lyricists.name
        vocalists.name
        genres.name
        tags.name
      ]

      # ファセット検索の設定
      faceting max_values_per_facet: 2000

      # フィルタリング可能な属性
      filterable_attributes %w[
        release_year
        release_month
        disc_number
        track_number
        original_song_count
        arranger_count
        composer_count
        lyricist_count
        vocalist_count
        is_touhou_arrangement
        circles.id
        original_songs.product_id
        arrangers.id
        composers.id
        lyricists.id
        vocalists.id
        genres.id
        tags.id
        original_songs.lvl0
        circles.name
        original_songs.product_name
        arrangers.name
        composers.name
        lyricists.name
        vocalists.name
        genres.name
        tags.name
      ]

      # ソート可能なフィールド
      sortable_attributes %w[
        release_date
        release_year
        release_month
        disc_number
        track_number
        original_song_count
        arranger_count
        composer_count
        lyricist_count
        vocalist_count
      ]

      # タイポ許容設定
      typo_tolerance({
        enabled: true,
        disable_on_attributes: %w[original_songs.lvl0 original_songs.lvl1 original_songs.lvl2],
        min_word_size_for_typos: {
          one_typo: 4,    # 4文字以上で1文字のタイポを許容
          two_typos: 8    # 8文字以上で2文字のタイポを許容
        }
      })

      # 検索ルール
      ranking_rules %w[
        words
        typo
        proximity
        attribute
        sort
        exactness
        release_date:desc
      ]

      # 検索時のハイライト設定
      displayed_attributes [
        "id",
        "slug",
        "name",
        "name_reading",
        "album_name",
        "album_name_reading",
        "album_slug",
        "circle_name",
        "circles",
        "release_date",
        "release_year",
        "release_month",
        "disc_number",
        "track_number",
        "length_time_ms",
        "bpm",
        "description",
        "note",
        "original_songs",
        "original_song_count",
        "arrangers",
        "arranger_count",
        "composers",
        "composer_count",
        "lyricists",
        "lyricist_count",
        "vocalists",
        "vocalist_count",
        "genres",
        "tags",
        "streamable_urls",
        "is_touhou_arrangement"
      ]

      # 検索結果のハイライト設定
      attributes_to_highlight %w[
        name
        name_reading
        album_name
        album_name_reading
        circle_name
        circles.name
        original_songs.name
        original_songs.lvl0
        original_songs.lvl1
        original_songs.lvl2
        arrangers.name
        composers.name
        lyricists.name
        vocalists.name
        genres.name
        tags.name
      ]

      # インデックスに含める属性を定義
      attribute :id
      attribute :slug
      attribute :name
      attribute :name_reading
      attribute :album_name do
        album&.name
      end
      attribute :album_name_reading do
        album&.name_reading
      end
      attribute :album_slug do
        album&.slug
      end
      attribute :circle_name do
        circle&.name
      end
      attribute :circles do
        arrange_circles.map { |c| { id: c.id, name: c.name } }
      end
      attribute :release_date do
        album&.release_date
      end
      attribute :release_year do
        album&.release_year
      end
      attribute :release_month do
        album&.release_month
      end
      attribute :disc_number
      attribute :track_number
      attribute :length_time_ms
      attribute :bpm
      attribute :description
      attribute :note
      attribute :original_songs do
        original_songs.map do |os|
          {
            id: os.id,
            name: os.name,
            lvl0: generate_level0(os),
            lvl1: generate_level1(os),
            lvl2: generate_level2(os),
            product_id: os.product&.id,
            product_name: os.product&.name,
            product_short_name: os.product&.short_name
          }
        end
      end
      attribute :original_song_count do
        original_songs.size
      end
      attribute :arrangers do
        arrangers.map { |a| { id: a.id, name: a.name } }
      end
      attribute :arranger_count do
        arrangers.size
      end
      attribute :rearrangers do
        rearrangers.map { |a| { id: a.id, name: a.name } }
      end
      attribute :rearranger_count do
        rearrangers.size
      end
      attribute :composers do
        composers.map { |c| { id: c.id, name: c.name } }
      end
      attribute :composer_count do
        composers.size
      end
      attribute :lyricists do
        lyricists.map { |l| { id: l.id, name: l.name } }
      end
      attribute :lyricist_count do
        lyricists.size
      end
      attribute :vocalists do
        vocalists.map { |v| { id: v.id, name: v.name } }
      end
      attribute :vocalist_count do
        vocalists.size
      end
      attribute :genres do
        genres.map { |g| { id: g.id, name: g.name } }
      end
      attribute :tags do
        tags.map { |t| { id: t.id, name: t.name } }
      end
      attribute :streamable_urls do
        streamable_urls.map { |u| { service: u.service, url: u.url } }
      end
      attribute :is_touhou_arrangement do
        original_songs.any?(&:is_touhou_arrangement?)
      end
    end
  end

  private

  PRODUCT_TYPE_MAP = {
    "pc98" => "02. PC98作品",
    "windows" => "01. Windows作品",
    "zuns_music_collection" => "03. ZUN's Music Collection",
    "akyus_untouched_score" => "04. 幺樂団の歴史　～ Akyu's Untouched Score",
    "commercial_books" => "05. 商業書籍",
    "tasofro" => "06. 黄昏フロンティア作品",
    "other" => "07. その他"
  }.freeze

  def generate_level0(original_song)
    PRODUCT_TYPE_MAP[original_song.product&.product_type]
  end

  def generate_level1(original_song)
    product = original_song.product
    return nil unless product

    "#{PRODUCT_TYPE_MAP[product.product_type]} > %04.1f. #{product.short_name}" % product.series_number
  end

  def generate_level2(original_song)
    product = original_song.product
    return nil unless product

    "#{PRODUCT_TYPE_MAP[product.product_type]} > %04.1f. #{product.short_name} > %02d. #{original_song.name}" % [ product.series_number, original_song.track_number ]
  end
end
