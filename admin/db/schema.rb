# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_18_055109) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "first_character_type", ["symbol", "number", "alphabet", "hiragana", "katakana", "kanji", "other"]
  create_enum "product_type", ["pc98", "windows", "zuns_music_collection", "akyus_untouched_score", "commercial_books", "tasofro", "other"]

  create_table "album_discs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アルバムディスクID" }, comment: "アルバムが複数ディスクで構成される場合に各ディスクの情報（番号、名称、説明）を管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "album_id", null: false, comment: "アルバムID"
    t.integer "disc_number", comment: "ディスクの通し番号（1枚目=1、2枚目=2など）"
    t.text "name", comment: "ディスク名（必要な場合）"
    t.text "description", comment: "ディスクに関する説明（例: ボーナスディスクの詳細など）"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["album_id"], name: "idx_album_discs_album_id"
    t.index ["disc_number"], name: "idx_album_discs_disc_number"
    t.index ["position"], name: "idx_album_discs_position"
  end

  create_table "album_prices", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アルバム価格のID" }, comment: "アルバム価格情報を管理（イベント価格、ショップ価格、無料頒布など）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "album_id", null: false, comment: "アルバムID"
    t.text "price_type", null: false, comment: "価格の種類(event: イベント価格, shop: 通常価格)"
    t.boolean "is_free", default: false, null: false, comment: "無料頒布有無(true: 無料頒布, false: 有料頒布)"
    t.decimal "price", null: false, comment: "価格"
    t.text "currency", default: "JPY", null: false, comment: "通貨(default: JPY)"
    t.boolean "tax_included", default: false, null: false, comment: "税込みか否か(true: 税込み、false: 税抜き・税別)"
    t.uuid "shop_id", comment: "ショップID（NULL可、ある場合はshopsテーブルを参照）"
    t.text "url", comment: "URL"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["album_id", "price_type"], name: "idx_album_prices_album_id_price_type"
    t.index ["album_id", "shop_id"], name: "uk_ap_album_id_shop_id", unique: true
    t.index ["album_id"], name: "idx_album_prices_album_id"
    t.index ["price_type", "is_free", "currency"], name: "idx_album_prices_combined"
    t.index ["price_type"], name: "idx_album_prices_price_type"
    t.index ["shop_id", "price_type"], name: "idx_album_prices_shop_id_price_type"
    t.index ["shop_id"], name: "idx_album_prices_shop_id"
    t.check_constraint "is_free = true AND price = 0::numeric OR is_free = false AND price > 0::numeric", name: "album_prices_check"
    t.check_constraint "price_type = ANY (ARRAY['event'::text, 'shop'::text])", name: "album_prices_price_type_check"
  end

  create_table "album_upcs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アルバムUPCのID" }, comment: "アルバムに付与されるUPC(JAN)コードを管理するテーブル（商品バーコード情報）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "album_id", null: false, comment: "アルバムID"
    t.text "upc", null: false, comment: "アルバムに割り当てられたUPC(JAN)コード(バーコード)"
    t.integer "position", default: 1, null: false, comment: "複数UPCがある場合の並び順"
    t.index ["album_id", "upc"], name: "uk_album_upcs_album_id_upc", unique: true
    t.index ["album_id"], name: "idx_album_upcs_album_id"
    t.index ["position"], name: "idx_album_upcs_position"
  end

  create_table "albums", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アルバムID" }, comment: "東方アレンジアルバム情報を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "名前"
    t.text "name_reading", comment: "名前読み方"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "スラッグ"
    t.uuid "release_circle_id", comment: "頒布サークルID"
    t.text "release_circle_name", comment: "頒布サークル名"
    t.date "release_date", comment: "頒布日"
    t.integer "release_year", comment: "頒布年"
    t.integer "release_month", comment: "頒布月"
    t.uuid "event_day_id", comment: "イベント日程ID"
    t.text "album_number"
    t.text "credit", comment: "クレジット"
    t.text "introduction", comment: "紹介"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.text "url", comment: "URL"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index "COALESCE(published_at, '1970-01-01 00:00:00+00'::timestamp with time zone), COALESCE(archived_at, '9999-12-31 00:00:00+00'::timestamp with time zone)", name: "idx_albums_publication_status"
    t.index ["archived_at"], name: "idx_albums_archived_at"
    t.index ["event_day_id"], name: "idx_albums_event_day_id"
    t.index ["published_at"], name: "idx_albums_published_at"
    t.index ["release_circle_id"], name: "idx_albums_release_circle_id"
    t.index ["release_date"], name: "idx_albums_release_date"
    t.index ["release_month"], name: "idx_albums_release_month"
    t.index ["release_year", "release_month", "release_date"], name: "idx_albums_comprehensive_release"
    t.index ["release_year", "release_month"], name: "idx_albums_release_year_month"
    t.index ["release_year"], name: "idx_albums_release_year"
    t.unique_constraint ["slug"], name: "albums_slug_key"
  end

  create_table "albums_circles", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アルバムとサークルの中間テーブルのID" }, comment: "アルバムとサークルを関連付ける中間テーブル（1枚のアルバムに複数サークルが関与するケースをサポート）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "album_id", null: false, comment: "関与するアルバムのID"
    t.uuid "circle_id", null: false, comment: "関与するサークルのID"
    t.integer "position", default: 1, null: false, comment: "複数サークルが関わる場合の表示順序"
    t.index ["album_id", "circle_id"], name: "uk_albums_circles_album_id_circle_id", unique: true
    t.index ["album_id"], name: "idx_albums_circles_album_id"
    t.index ["circle_id"], name: "idx_albums_circles_circle_id"
    t.index ["position"], name: "idx_albums_circles_position"
  end

  create_table "artist_names", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アーティスト名ID" }, comment: "アーティストの本名義・別名義を一元管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "artist_id", null: false, comment: "アーティストID"
    t.text "name", null: false, comment: "アーティストの名義（本名義または別名義）"
    t.text "name_reading", comment: "名義の読み方"
    t.boolean "is_main_name", default: false, null: false, comment: "この名義が本名義かどうか(trueの場合、本名義)"
    t.enum "first_character_type", null: false, comment: "頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)", enum_type: "first_character_type"
    t.text "first_character", comment: "頭文字詳細(英字、ひらがな、カタカナの場合のみ)"
    t.text "first_character_row", comment: "頭文字の行 (ひらがな、カタカナの場合のみ)"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.index ["archived_at"], name: "idx_artist_names_archived_at"
    t.index ["artist_id", "is_main_name"], name: "uk_artist_names_artist_id_main_name", unique: true, where: "(is_main_name = true)"
    t.index ["artist_id"], name: "idx_artist_names_artist_id"
    t.index ["first_character_type", "first_character", "first_character_row"], name: "idx_artist_names_comprehensive"
    t.index ["first_character_type", "first_character"], name: "idx_artist_names_first_character"
    t.index ["first_character_type"], name: "idx_artist_names_first_character_type"
    t.index ["published_at"], name: "idx_artist_names_published_at"
    t.check_constraint "(first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character IS NOT NULL OR (first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character IS NULL", name: "artist_names_check"
    t.check_constraint "(first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character_row IS NOT NULL OR (first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character_row IS NULL", name: "artist_names_check1"
  end

  create_table "artist_roles", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アーティスト役割ID" }, comment: "アーティストが担う役割(作曲/編曲など)を定義するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "役割名 (vocalist, composer, arranger, rearranger, lyricistなど)"
    t.text "display_name", null: false, comment: "表示名"
    t.text "description", comment: "役割の説明"
    t.text "note", comment: "備考"

    t.unique_constraint ["name"], name: "artist_roles_name_key"
  end

  create_table "artists", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "アーティストID" }, comment: "アーティスト本体。名義はartist_namesで細かく管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "管理名"
    t.text "note", comment: "備考"
    t.index ["name"], name: "uk_artists_name", unique: true
  end

  create_table "circles", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "サークルID" }, comment: "サークル情報（同人音楽サークルなど）を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "名前"
    t.text "name_reading", comment: "名前読み方"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "スラッグ"
    t.enum "first_character_type", null: false, comment: "頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)", enum_type: "first_character_type"
    t.text "first_character", comment: "頭文字詳細(英字、ひらがな、カタカナの場合のみ)"
    t.text "first_character_row", comment: "頭文字の行 (ひらがな、カタカナの場合のみ)"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.index ["archived_at"], name: "idx_circles_archived_at"
    t.index ["first_character_type", "first_character", "first_character_row"], name: "idx_circles_comprehensive"
    t.index ["first_character_type", "first_character"], name: "idx_circles_first_character"
    t.index ["first_character_type"], name: "idx_circles_first_character_type"
    t.index ["name"], name: "uk_circles_name", unique: true
    t.index ["published_at"], name: "idx_circles_published_at"
    t.check_constraint "(first_character_type = ANY (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character IS NOT NULL OR (first_character_type <> ALL (ARRAY['alphabet'::first_character_type, 'hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character IS NULL", name: "circles_check"
    t.check_constraint "(first_character_type = ANY (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character_row IS NOT NULL OR (first_character_type <> ALL (ARRAY['hiragana'::first_character_type, 'katakana'::first_character_type])) AND first_character_row IS NULL", name: "circles_check1"
    t.unique_constraint ["slug"], name: "circles_slug_key"
  end

  create_table "distribution_services", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "配信サービスID" }, comment: "音楽配信サービス（Spotify, Apple Music等）の基本情報を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "service_name", null: false, comment: "サービス名"
    t.text "display_name", null: false, comment: "表示名"
    t.jsonb "base_urls", null: false, comment: "サービスのベースURLの配列（[\"https://open.spotify.com/\"]）"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false
    t.index ["base_urls"], name: "idx_distribution_services_base_urls", using: :gin
    t.index ["position"], name: "idx_distribution_services_position"
    t.unique_constraint ["service_name"], name: "distribution_services_service_name_key"
  end

  create_table "event_days", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "イベント日程ID" }, comment: "イベント開催回内の日程（複数日開催の場合など）を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "event_edition_id", null: false, comment: "イベント開催回ID"
    t.integer "day_number", comment: "日程の順序"
    t.text "display_name", comment: "表示名"
    t.date "event_date", comment: "開催日"
    t.text "region_code", default: "JP", null: false, comment: "地域コード オンラインの場合はGlobal/default: JP"
    t.boolean "is_cancelled", default: false, null: false, comment: "中止か否か"
    t.boolean "is_online", default: false, null: false, comment: "オンライン開催か否か"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["archived_at"], name: "idx_event_days_archived_at"
    t.index ["event_date"], name: "idx_event_days_event_date"
    t.index ["event_edition_id", "day_number", "is_online"], name: "uk_event_days_event_edition_id_day_number_is_online", unique: true
    t.index ["event_edition_id", "event_date", "is_cancelled", "is_online"], name: "idx_event_days_comprehensive"
    t.index ["event_edition_id"], name: "idx_event_days_event_edition_id"
    t.index ["is_cancelled"], name: "idx_event_days_is_cancelled"
    t.index ["is_online"], name: "idx_event_days_is_online"
    t.index ["published_at"], name: "idx_event_days_published_at"
    t.index ["region_code"], name: "idx_event_days_region_code"
  end

  create_table "event_editions", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "イベント開催回ID" }, comment: "イベントシリーズの特定開催回(例: コミケ〇〇回)を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "event_series_id", null: false, comment: "イベントシリーズID"
    t.text "name", null: false, comment: "管理名"
    t.text "display_name", null: false, comment: "表示名"
    t.text "display_name_reading", comment: "表示名読み仮名"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "スラッグ"
    t.date "start_date", comment: "開始日"
    t.date "end_date", comment: "終了日"
    t.date "touhou_date", comment: "東方Projectの開催日(コミケの場合のみ使用する)"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.text "url", comment: "URL"
    t.text "twitter_url", comment: "Twitter URL"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false
    t.index ["archived_at"], name: "idx_event_editions_archived_at"
    t.index ["end_date"], name: "idx_event_editions_end_date"
    t.index ["event_series_id", "name"], name: "uk_event_editions_event_series_id_name", unique: true
    t.index ["event_series_id"], name: "idx_event_editions_event_series_id"
    t.index ["position"], name: "idx_event_editions_position"
    t.index ["published_at"], name: "idx_event_editions_published_at"
    t.index ["start_date"], name: "idx_event_editions_start_date"
    t.index ["touhou_date"], name: "idx_event_editions_touhou_date"
    t.unique_constraint ["slug"], name: "event_editions_slug_key"
  end

  create_table "event_series", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "イベントシリーズID" }, comment: "イベントシリーズ", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "管理名"
    t.text "display_name", null: false, comment: "表示名"
    t.text "display_name_reading", comment: "表示名読み仮名"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "スラッグ"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false
    t.index ["archived_at"], name: "idx_event_series_archived_at"
    t.index ["position"], name: "idx_event_series_position"
    t.index ["published_at"], name: "idx_event_series_published_at"
    t.unique_constraint ["name"], name: "event_series_name_key"
    t.unique_constraint ["slug"], name: "event_series_slug_key"
  end

  create_table "genreable_genres", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "エンティティジャンルID" }, comment: "アルバム、サークル、アーティストなどにジャンルを割り当てる中間テーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "genreable_type", null: false, comment: "対象の種別（Album, Circle, ArtistNameのいずれか）"
    t.uuid "genreable_id", null: false, comment: "対象のID（アルバムID、サークルID、アーティストネームID）"
    t.uuid "genre_id", null: false, comment: "割り当てるジャンルID"
    t.timestamptz "locked_at", comment: "ジャンル付与情報をロックする日時"
    t.integer "position", default: 1, null: false
    t.index ["genreable_type", "genreable_id", "genre_id"], name: "uk_genreable_genres_genreable_type_genreable_id_genre_id", unique: true
    t.index ["locked_at"], name: "idx_genreable_genres_locked_at"
    t.index ["position"], name: "idx_genreable_genres_position"
    t.check_constraint "genreable_type = ANY (ARRAY['Album'::text, 'Circle'::text, 'ArtistName'::text])", name: "genreable_genres_genreable_type_check"
  end

  create_table "genres", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "ジャンルID" }, comment: "ジャンル情報を管理するテーブル（ロック、ジャズ、エレクトロなど）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "ジャンル名（ユニーク）"
    t.text "description", comment: "ジャンルの簡易説明"
    t.text "note", comment: "ジャンルに関する補足情報"

    t.unique_constraint ["name"], name: "genres_name_key"
  end

  create_table "news", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "お知らせID" }, comment: "サイトのお知らせ情報を管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "title", null: false, comment: "お知らせタイトル"
    t.text "content", null: false, comment: "お知らせ本文"
    t.text "summary", comment: "お知らせ概要（一覧表示用）"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "URLフレンドリーな識別子"
    t.timestamptz "published_at", null: false, comment: "公開日時（この日時以降に表示される）"
    t.timestamptz "expired_at", comment: "有効期限（この日時以降は表示されない、NULLの場合は無期限）"
    t.boolean "is_important", default: false, null: false, comment: "重要なお知らせかどうか（強調表示などに使用）"
    t.text "category", comment: "お知らせのカテゴリ（更新情報、メンテナンス情報など）"
    t.index "published_at, COALESCE(expired_at, '9999-12-31 00:00:00+00'::timestamp with time zone)", name: "idx_news_publication_status"
    t.index ["category"], name: "idx_news_category"
    t.index ["expired_at"], name: "idx_news_expired_at"
    t.index ["is_important"], name: "idx_news_is_important"
    t.index ["published_at"], name: "idx_news_published_at"
    t.unique_constraint ["slug"], name: "news_slug_key"
  end

  create_table "original_songs", id: { type: :text, comment: "原曲ID" }, comment: "東方Projectの原曲データ（初出曲や既存曲の再録元など）を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "product_id", null: false, comment: "原作ID"
    t.text "name", null: false, comment: "名前"
    t.text "name_reading", comment: "名前読み方"
    t.text "composer", comment: "作曲者"
    t.text "arranger", comment: "編曲者"
    t.integer "track_number", null: false, comment: "トラック番号"
    t.boolean "is_original", default: false, null: false, comment: "この原曲がシリーズ初登場(オリジナル)であるかを示すフラグ。trueの場合は初出のオリジナル原曲、falseの場合は既存原曲からの再録や派生版。"
    t.text "origin_original_song_id", comment: "原曲元の原曲ID(同テーブル参照)"
    t.index ["is_original"], name: "idx_original_songs_is_original"
    t.index ["origin_original_song_id"], name: "idx_original_songs_origin_original_song_id"
    t.index ["product_id", "is_original"], name: "idx_original_songs_product_original"
    t.index ["product_id"], name: "idx_original_songs_product_id"
    t.index ["track_number"], name: "idx_original_songs_track_number"
  end

  create_table "products", id: { type: :text, comment: "原作を一意に識別するID" }, comment: "東方Project関連の原作作品（ゲーム、CD、書籍等）を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "原作作品名（正式名称）"
    t.text "name_reading"
    t.text "short_name", null: false, comment: "省略名や略称（表示用や検索用）"
    t.enum "product_type", null: false, comment: "作品の種類を区分する（PC-98、Windows版、商業書籍など）", enum_type: "product_type"
    t.decimal "series_number", precision: 5, scale: 2, null: false, comment: "シリーズ中での作品番号（数値順で作品を並べるために使用）"
    t.index ["product_type"], name: "idx_products_product_type"
    t.index ["series_number"], name: "idx_products_series_number"
  end

  create_table "reference_urls", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "エンティティURL ID" }, comment: "アーティスト名やサークルに紐づく任意のURLを柔軟に格納するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "referenceable_type", null: false, comment: "リファレンス種別(ArtistName, Circle, Album, Songなど)"
    t.uuid "referenceable_id", null: false, comment: "リファレンスID"
    t.text "url_type", null: false, comment: "URL種別(例: official, twitter, youtube, blogなど)"
    t.text "url", null: false, comment: "URL"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["referenceable_type", "referenceable_id", "url"], name: "uk_reference_urls_referenceable_type_referenceable_id_url", unique: true
    t.index ["referenceable_type", "referenceable_id"], name: "idx_reference_urls_referenceable"
    t.index ["url_type"], name: "idx_reference_urls_url_type"
    t.check_constraint "referenceable_type = ANY (ARRAY['ArtistName'::text, 'Album'::text, 'Circle'::text, 'Song'::text])", name: "reference_urls_referenceable_type_check"
  end

  create_table "shops", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "ショップID" }, comment: "CDや関連グッズを扱う各ショップ(販売店/同人ショップ)の情報を管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "内部システムで用いるショップの識別名(ユニーク)"
    t.text "display_name", null: false, comment: "表示用のショップ名（ユーザーや外部表示用）"
    t.text "description", comment: "ショップの説明"
    t.text "note", comment: "備考"
    t.text "website_url", comment: "公式サイトURL（ユーザーがアクセス可能なURL）"
    t.jsonb "base_urls", comment: "このショップに関連するベースURLリスト(json形式)"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["archived_at"], name: "idx_shops_archived_at"
    t.index ["position"], name: "idx_shops_position"
    t.index ["published_at"], name: "idx_shops_published_at"
    t.unique_constraint ["name"], name: "shops_name_key"
  end

  create_table "song_bmps", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲BPMのID" }, comment: "楽曲内でのBPM情報（BPM変化箇所）を管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.integer "bpm", null: false, comment: "BPM値（1分あたりのビート数）"
    t.bigint "start_time_ms", comment: "このBPMが適用される開始時刻(ミリ秒)"
    t.bigint "end_time_ms", comment: "このBPMが適用される終了時刻(ミリ秒)"
    t.integer "position", default: 1, null: false, comment: "楽曲が持つBPMの順序"
    t.index ["position"], name: "idx_song_bmps_position"
    t.index ["song_id"], name: "idx_song_bmps_song_id"
  end

  create_table "song_isrcs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲ISRCのID" }, comment: "楽曲に対応するISRC(国際標準レコーディングコード)を管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.text "isrc", null: false, comment: "ISRCコード（世界共通の音源識別子）"
    t.integer "position", default: 1, null: false, comment: "楽曲が持つISRCの順序"
    t.index ["position"], name: "idx_song_isrcs_position"
    t.index ["song_id", "isrc"], name: "uk_song_isrcs_song_id_isrc", unique: true
    t.index ["song_id"], name: "idx_song_isrcs_song_id"
  end

  create_table "song_lyrics", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "歌詞ID" }, comment: "楽曲に対応する歌詞情報を管理するテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.text "content", null: false, comment: "歌詞本文"
    t.text "language", default: "ja", comment: "歌詞の言語コード（例: \"ja\" = 日本語）"
    t.text "description", comment: "この歌詞に関する説明（翻訳元やバージョン違いの説明など）"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false, comment: "楽曲が持つ歌詞の順序"
    t.index ["position"], name: "idx_song_lyrics_position"
    t.index ["song_id"], name: "idx_song_lyrics_song_id"
  end

  create_table "songs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲ID" }, comment: "楽曲情報を管理するテーブル（アルバム収録曲や単独頒布曲などの基本情報）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "circle_id", comment: "サークルID（NULL可、あればcirclesテーブル参照）"
    t.uuid "album_id", comment: "アルバムID（NULL可、あればalbumsテーブル参照）"
    t.text "name", null: false, comment: "楽曲名（正式タイトル）"
    t.text "name_reading", comment: "名前読み方"
    t.date "release_date", comment: "頒布日(アルバムの頒布日と異なる場合に使用する)"
    t.integer "release_year", comment: "頒布年"
    t.integer "release_month", comment: "頒布月"
    t.text "slug", default: -> { "gen_random_uuid()" }, null: false, comment: "URLなどで使用する一意識別子（ランダム生成された文字列）"
    t.uuid "album_disc_id", comment: "アルバムディスクID（NULL可、あればalbum_discsテーブル参照）"
    t.integer "disc_number", comment: "ディスク番号"
    t.integer "track_number", comment: "トラック番号"
    t.integer "length_time_ms", comment: "曲の長さ(ミリ秒)"
    t.integer "bpm", comment: "BPM"
    t.text "description", comment: "楽曲に関する説明文（特徴、背景、解説など）"
    t.text "note", comment: "メモや補足情報（内部用、注釈など）"
    t.text "display_composer", comment: "特定条件下で表示する作曲者名（メイン以外の名義など）"
    t.text "display_arranger", comment: "特定条件下で表示する編曲者名（メイン以外の名義など）"
    t.text "display_rearranger", comment: "再編曲者表示名（別名義など特例的な表示用）"
    t.text "display_lyricist", comment: "特定条件下で表示する作詞者名"
    t.text "display_vocalist", comment: "特定条件下で表示するボーカリスト名"
    t.text "display_original_song", comment: "原曲表示用（東方以外や特殊な原曲を示す際に使用）"
    t.timestamptz "published_at", comment: "公開日時"
    t.timestamptz "archived_at", comment: "アーカイブ日時"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["album_id", "disc_number", "track_number"], name: "idx_songs_disc_tracking"
    t.index ["album_id", "track_number"], name: "idx_songs_album_track"
    t.index ["album_id"], name: "idx_songs_album_id"
    t.index ["archived_at"], name: "idx_songs_archived_at"
    t.index ["circle_id"], name: "idx_songs_circle_id"
    t.index ["published_at"], name: "idx_songs_published_at"
    t.index ["release_date"], name: "idx_songs_release_date"
    t.index ["release_month"], name: "idx_songs_release_month"
    t.index ["release_year", "release_month", "release_date"], name: "idx_songs_comprehensive_release"
    t.index ["release_year", "release_month"], name: "idx_songs_release_year_month"
    t.index ["release_year"], name: "idx_songs_release_year"
    t.unique_constraint ["slug"], name: "songs_slug_key"
  end

  create_table "songs_arrange_circles", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲編曲サークルID" }, comment: "楽曲の編曲に関わったサークルを関連付けるテーブル（複数サークルが関与する場合に対応）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.uuid "circle_id", null: false, comment: "編曲に関わったサークルID"
    t.integer "position", default: 1, null: false, comment: "編曲サークルが楽曲に対して持つ順序"
    t.index ["circle_id", "song_id", "position"], name: "idx_songs_arrange_circles_combined"
    t.index ["circle_id"], name: "idx_songs_arrange_circles_circle_id"
    t.index ["song_id", "circle_id"], name: "uk_songs_arrange_circles_song_id_circle_id", unique: true
    t.index ["song_id"], name: "idx_songs_arrange_circles_song_id"
  end

  create_table "songs_artist_roles", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "主キーID" }, comment: "楽曲に参加するアーティストの名義と役割（作曲、編曲、ボーカルなど）を関連付けるテーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.uuid "artist_name_id", null: false, comment: "アーティスト名ID（artist_namesテーブル参照、本名義・別名義を含む）"
    t.uuid "artist_role_id", null: false, comment: "役割ID（artist_rolesテーブル参照）"
    t.text "connector", comment: "アーティスト名同士を結ぶ接続詞（\"vs\"、\"feat.\"など）"
    t.integer "position", default: 1, null: false, comment: "アーティストが曲に参加する順序"
    t.index ["artist_name_id"], name: "idx_songs_artist_roles_artist_name_id"
    t.index ["artist_role_id"], name: "idx_songs_artist_roles_artist_role_id"
    t.index ["song_id", "artist_name_id", "artist_role_id"], name: "uk_sar_song_id_artist_name_id_artist_role_id", unique: true
    t.index ["song_id", "artist_role_id", "position"], name: "idx_songs_artist_roles_combined"
    t.index ["song_id"], name: "idx_songs_artist_roles_song_id"
  end

  create_table "songs_genres", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲ジャンルID" }, comment: "楽曲に紐づくジャンル情報を管理する中間テーブル（開始位置・終了位置で曲中の特定区間を示すことも可能）", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.uuid "genre_id", null: false, comment: "ジャンルID"
    t.bigint "start_time_ms", comment: "このジャンルが適用される楽曲内の開始時刻(ミリ秒)"
    t.bigint "end_time_ms", comment: "このジャンルが適用される楽曲内の終了時刻(ミリ秒)"
    t.timestamptz "locked_at", comment: "ジャンル情報を固定する日時（再編集不可などの運用制約に使用）"
    t.integer "position", default: 1, null: false, comment: "楽曲が持つジャンルの順序"
    t.index ["genre_id"], name: "idx_songs_genres_genre_id"
    t.index ["locked_at"], name: "idx_songs_genres_locked_at"
    t.index ["position"], name: "idx_songs_genres_position"
    t.index ["song_id", "genre_id"], name: "idx_songs_genres_song_id_genre_id"
    t.index ["song_id"], name: "idx_songs_genres_song_id"
  end

  create_table "songs_original_songs", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "楽曲原曲ID" }, comment: "楽曲と原曲の関連付けテーブル。1つの楽曲が複数の原曲を元にしている場合に対応可能", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.uuid "song_id", null: false, comment: "楽曲ID"
    t.text "original_song_id", null: false, comment: "元になった原曲ID（original_songsテーブル参照）"
    t.integer "position", default: 1, null: false, comment: "楽曲が原曲に対して持つ順序"
    t.index ["original_song_id"], name: "idx_songs_original_songs_original_song_id"
    t.index ["position"], name: "idx_songs_original_songs_position"
    t.index ["song_id", "original_song_id"], name: "uk_songs_original_songs_song_id_original_song_id", unique: true
    t.index ["song_id"], name: "idx_songs_original_songs_song_id"
  end

  create_table "streamable_urls", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "配信サービスURLのID" }, comment: "原作・原曲・アルバム・楽曲ごとに各配信サービスでのURLを管理", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "streamable_type", null: false, comment: "ストリーミング可能なエンティティのタイプ（原作、原曲、アルバム、楽曲）"
    t.text "streamable_id", null: false, comment: "ストリーミング可能なエンティティのID（原作ID、原曲ID、アルバムID、楽曲ID）"
    t.text "service_name", null: false, comment: "配信サービスの名称"
    t.text "url", null: false, comment: "URL"
    t.text "description", comment: "説明"
    t.text "note", comment: "備考"
    t.integer "position", default: 1, null: false, comment: "順序"
    t.index ["service_name"], name: "idx_streamable_urls_service_name"
    t.index ["streamable_type", "service_name"], name: "idx_streamable_urls_type_service"
    t.index ["streamable_type", "streamable_id", "service_name"], name: "uk_streamable_urls_streamable_id_service", unique: true
    t.check_constraint "streamable_type = ANY (ARRAY['Product'::text, 'OriginalSong'::text, 'Album'::text, 'Song'::text])", name: "streamable_urls_streamable_type_check"
  end

  create_table "taggings", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "タグ付けID" }, comment: "アルバム、楽曲、サークル、アーティストなど任意のエンティティにタグを付ける中間テーブル", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "taggable_type", null: false, comment: "対象の種別（Album, Song, Circle, ArtistName）"
    t.uuid "taggable_id", null: false, comment: "タグ付け対象のID"
    t.uuid "tag_id", null: false, comment: "付与するタグID"
    t.timestamptz "locked_at", comment: "タグ付与情報をロックする日時"
    t.integer "position", default: 1, null: false, comment: "タグがエンティティに対して持つ順序"
    t.index ["locked_at"], name: "idx_taggings_locked_at"
    t.index ["position"], name: "idx_taggings_position"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "uk_taggings_taggable", unique: true
    t.check_constraint "taggable_type = ANY (ARRAY['Album'::text, 'Song'::text, 'Circle'::text, 'ArtistName'::text])", name: "taggings_taggable_type_check"
  end

  create_table "tags", id: { type: :uuid, default: -> { "gen_random_uuid()" }, comment: "タグID" }, comment: "タグ情報を管理するテーブル。ジャンル以外の属性や特徴を自由に付与可能", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "作成日時"
    t.timestamptz "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "更新日時"
    t.text "name", null: false, comment: "タグ名（ユニーク）"
    t.text "description", comment: "タグに関する説明文"
    t.text "note", comment: "タグに関する補足情報"

    t.unique_constraint ["name"], name: "tags_name_key"
  end

  add_foreign_key "album_discs", "albums", name: "album_discs_album_id_fkey", on_delete: :cascade
  add_foreign_key "album_prices", "albums", name: "album_prices_album_id_fkey", on_delete: :cascade
  add_foreign_key "album_prices", "shops", name: "album_prices_shop_id_fkey", on_delete: :restrict
  add_foreign_key "album_upcs", "albums", name: "album_upcs_album_id_fkey", on_delete: :cascade
  add_foreign_key "albums", "circles", column: "release_circle_id", name: "albums_release_circle_id_fkey", on_delete: :restrict
  add_foreign_key "albums", "event_days", name: "albums_event_day_id_fkey", on_delete: :nullify
  add_foreign_key "albums_circles", "albums", name: "albums_circles_album_id_fkey", on_delete: :cascade
  add_foreign_key "albums_circles", "circles", name: "albums_circles_circle_id_fkey", on_delete: :cascade
  add_foreign_key "artist_names", "artists", name: "artist_names_artist_id_fkey", on_delete: :cascade
  add_foreign_key "event_days", "event_editions", name: "event_days_event_edition_id_fkey", on_delete: :cascade
  add_foreign_key "event_editions", "event_series", name: "event_editions_event_series_id_fkey", on_delete: :restrict
  add_foreign_key "genreable_genres", "genres", name: "genreable_genres_genre_id_fkey", on_delete: :cascade
  add_foreign_key "original_songs", "original_songs", column: "origin_original_song_id", name: "original_songs_origin_original_song_id_fkey", on_delete: :nullify
  add_foreign_key "original_songs", "products", name: "original_songs_product_id_fkey", on_delete: :restrict
  add_foreign_key "song_bmps", "songs", name: "song_bmps_song_id_fkey", on_delete: :cascade
  add_foreign_key "song_isrcs", "songs", name: "song_isrcs_song_id_fkey", on_delete: :cascade
  add_foreign_key "song_lyrics", "songs", name: "song_lyrics_song_id_fkey", on_delete: :cascade
  add_foreign_key "songs", "album_discs", name: "songs_album_disc_id_fkey", on_delete: :nullify
  add_foreign_key "songs", "albums", name: "songs_album_id_fkey", on_delete: :restrict
  add_foreign_key "songs", "circles", name: "songs_circle_id_fkey", on_delete: :restrict
  add_foreign_key "songs_arrange_circles", "circles", name: "songs_arrange_circles_circle_id_fkey", on_delete: :cascade
  add_foreign_key "songs_arrange_circles", "songs", name: "songs_arrange_circles_song_id_fkey", on_delete: :cascade
  add_foreign_key "songs_artist_roles", "artist_names", name: "songs_artist_roles_artist_name_id_fkey", on_delete: :cascade
  add_foreign_key "songs_artist_roles", "artist_roles", name: "songs_artist_roles_artist_role_id_fkey", on_delete: :cascade
  add_foreign_key "songs_artist_roles", "songs", name: "songs_artist_roles_song_id_fkey", on_delete: :cascade
  add_foreign_key "songs_genres", "genres", name: "songs_genres_genre_id_fkey", on_delete: :cascade
  add_foreign_key "songs_genres", "songs", name: "songs_genres_song_id_fkey", on_delete: :cascade
  add_foreign_key "songs_original_songs", "original_songs", name: "songs_original_songs_original_song_id_fkey", on_delete: :cascade
  add_foreign_key "songs_original_songs", "songs", name: "songs_original_songs_song_id_fkey", on_delete: :cascade
  add_foreign_key "streamable_urls", "distribution_services", column: "service_name", primary_key: "service_name", name: "streamable_urls_service_name_fkey", on_delete: :restrict
  add_foreign_key "taggings", "tags", name: "taggings_tag_id_fkey", on_delete: :cascade
end
