-- migrate:up
-- 各作品（原作）を表すテーブル
-- PC-98やWindows版、ZUNの音楽CDなどの出典を管理する
create type product_type as enum (
    'pc98',                  -- PC-98作品
    'windows',               -- Windows作品
    'zuns_music_collection', -- ZUN's Music Collection
    'akyus_untouched_score', -- 幺樂団の歴史
    'commercial_books',      -- 商業書籍
    'tasofro',               -- 黄昏フロンティア作品
    'other'                  -- 上記以外
);

-- 原作テーブル: 東方Project関連の作品(ゲーム、CD、書籍等)を管理
create table products (
    id            text                     not null primary key,
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp,
    name          text                     not null, -- 原作作品名（例: 東方紅魔郷）
    name_reading  text,                    -- 作品名の読み仮名
    short_name    text                     not null, -- 短縮名（略称）
    product_type  product_type             not null,  -- 作品タイプ(enum)
    series_number numeric(5,2)             not null    -- シリーズ中での作品番号（例: 6.00 = 東方紅魔郷）
);
create index idx_products_product_type on products (product_type);
create index idx_products_series_number on products (series_number);
comment on table products is '東方Project関連の原作作品（ゲーム、CD、書籍等）を管理';
comment on column products.id is '原作を一意に識別するID';
comment on column products.created_at is '作成日時';
comment on column products.updated_at is '更新日時';
comment on column products.name is '原作作品名（正式名称）';
comment on column products.short_name is '省略名や略称（表示用や検索用）';
comment on column products.product_type is '作品の種類を区分する（PC-98、Windows版、商業書籍など）';
comment on column products.series_number is 'シリーズ中での作品番号（数値順で作品を並べるために使用）';

-- 原曲テーブル: 東方原曲を管理
-- オリジナル初出曲や既存曲の再録・アレンジ元などの情報
create table original_songs (
    id                      text                     not null primary key,
    created_at              timestamp with time zone not null default current_timestamp,
    updated_at              timestamp with time zone not null default current_timestamp,
    product_id              text                     not null references products(id) on delete restrict, -- どの原作作品に属するか
    name                    text                     not null, -- 原曲名
    name_reading            text,                    -- 原曲名読み方
    composer                text,                    -- 作曲者
    arranger                text,                    -- 編曲者（原作側）
    track_number            integer                  not null, -- 作品中でのトラック番号
    is_original             boolean                  not null default false, -- 初出オリジナル曲か否か
    origin_original_song_id text references original_songs(id) on delete set null -- 派生元となった原曲ID
);
create index idx_original_songs_product_id on original_songs (product_id);
create index idx_original_songs_track_number on original_songs (track_number);
create index idx_original_songs_is_original on original_songs (is_original);
create index idx_original_songs_origin_original_song_id on original_songs (origin_original_song_id);
comment on table original_songs is '東方Projectの原曲データ（初出曲や既存曲の再録元など）を管理';
comment on column original_songs.id is '原曲ID';
comment on column original_songs.product_id is '原作ID';
comment on column original_songs.created_at is '作成日時';
comment on column original_songs.updated_at is '更新日時';
comment on column original_songs.id is '原曲ID';
comment on column original_songs.name is '名前';
comment on column original_songs.name_reading is '名前読み方';
comment on column original_songs.composer is '作曲者';
comment on column original_songs.arranger is '編曲者';
comment on column original_songs.track_number is 'トラック番号';
comment on column original_songs.is_original is 'この原曲がシリーズ初登場(オリジナル)であるかを示すフラグ。trueの場合は初出のオリジナル原曲、falseの場合は既存原曲からの再録や派生版。';
comment on column original_songs.origin_original_song_id is '原曲元の原曲ID(同テーブル参照)';

/* create type distribution_service as enum (
    'spotify',
    'apple_music',
    'youtube_music',
    'line_music',
    'itunes',
    'youtube',
    'nicovideo',
    'sound_cloud'
); */

-- 配信サービス情報テーブル: SpotifyやApple Musicなどの音楽配信サービスを管理
create table distribution_services (
    id           uuid primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    service_name text not null unique, -- サービス内部名（例: spotify）
    display_name text not null,        -- ユーザー向け表示名（例: Spotify）
    base_urls    jsonb not null,       -- サービスの基本URLリスト（例: ["https://open.spotify.com/"]）
    description  text,                 -- サービスの説明文
    note         text,                 -- メモや補足
    position     integer not null default 1
);
create index idx_distribution_services_position on distribution_services (position);
comment on table distribution_services is '音楽配信サービス（Spotify, Apple Music等）の基本情報を管理';
comment on column distribution_services.id is '配信サービスID';
comment on column distribution_services.created_at is '作成日時';
comment on column distribution_services.updated_at is '更新日時';
comment on column distribution_services.service_name is 'サービス名';
comment on column distribution_services.display_name is '表示名';
comment on column distribution_services.base_urls is 'サービスのベースURLの配列（["https://open.spotify.com/"]）';
comment on column distribution_services.description is '説明';
comment on column distribution_services.note is '備考';

-- 配信サービスURLテーブル: 原曲やアルバムなど各エンティティがどの配信サービス上でどのURLなのかを管理
-- 例えば原曲XがSpotify上でどのURLにあるか、アルバムYがYouTube MusicでどのURLなのか
create table distribution_service_urls (
    id              uuid                     not null primary key default gen_random_uuid(),
    created_at      timestamp with time zone not null default current_timestamp,
    updated_at      timestamp with time zone not null default current_timestamp,
    entity_type     text                     not null check (entity_type in ('product', 'original_song', 'album', 'song')), 
      -- 管理対象の種別: 原作(product)、原曲(original_song)、アルバム(album)、楽曲(song)
    entity_id       uuid                     not null,  -- 対象エンティティのID
    service_name    text                     not null references distribution_services(service_name) on delete restrict, -- 紐づく配信サービス
    url             text                     not null, -- 実際の配信URL
    description     text,                    -- URLに関する説明（バージョン違いなど）
    note            text,                    -- メモ
    position        integer                  not null default 1
);
create unique index uk_dsu_entity_id_service on distribution_service_urls (entity_type, entity_id, service_name);
create index idx_dsu_service_name on distribution_service_urls (service_name);
comment on table distribution_service_urls is '原作・原曲・アルバム・楽曲ごとに各配信サービスでのURLを管理';
comment on column distribution_service_urls.id is '配信サービスURLのID';
comment on column distribution_service_urls.created_at is '作成日時';
comment on column distribution_service_urls.updated_at is '更新日時';
comment on column distribution_service_urls.entity_type is 'エンティティのタイプ（原作、原曲、アルバム、楽曲）';
comment on column distribution_service_urls.entity_id is 'エンティティのID（原作ID、原曲ID、アルバムID、楽曲ID）';
comment on column distribution_service_urls.service_name is '配信サービスの名称';
comment on column distribution_service_urls.url is 'URL';
comment on column distribution_service_urls.description is '説明';
comment on column distribution_service_urls.note is '備考';
comment on column distribution_service_urls.position is '順序';

-- イベントシリーズテーブル: 例) コミックマーケット、博麗神社例大祭などのシリーズ全体
create table event_series (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    name         text                     not null unique,  -- システム管理名(内部名)
    display_name text                     not null,         -- ユーザー向け表示名
    slug         text                     not null unique default gen_random_uuid(), -- 外部公開用の簡易識別子
    published_at timestamp with time zone, -- 公開日時
    archived_at  timestamp with time zone, -- アーカイブ日時
    position     integer                  not null default 1
);
create index idx_event_series_published_at on event_series (published_at);
create index idx_event_series_archived_at on event_series (archived_at);
create index idx_event_series_position on event_series (position);
comment on table  event_series is 'イベントシリーズ';
comment on column event_series.id is 'イベントシリーズID';
comment on column event_series.created_at is '作成日時';
comment on column event_series.updated_at is '更新日時';
comment on column event_series.name is '管理名';
comment on column event_series.display_name is '表示名';
comment on column event_series.slug is 'スラッグ';
comment on column event_series.published_at is '公開日時';
comment on column event_series.archived_at is 'アーカイブ日時';

-- イベント開催回テーブル: シリーズの特定回を表す（例: コミケ104回）
create table event_editions (
    id              uuid                     not null primary key default gen_random_uuid(),
    created_at      timestamp with time zone not null default current_timestamp,
    updated_at      timestamp with time zone not null default current_timestamp,
    event_series_id uuid                     not null references event_series(id) on delete restrict,
    name            text                     not null,  -- 開催回内部名
    display_name    text                     not null,  -- ユーザー表示名（例: "コミックマーケット104"）
    slug            text                     not null unique default gen_random_uuid(),
    start_date      date,                    -- 開催開始日
    end_date        date,                    -- 開催終了日
    description     text,                    -- この開催回に関する説明
    note            text,                    -- メモ
    url             text,                    -- イベント公式URL
    twitter_url     text,                    -- イベント公式Twitter URL
    published_at    timestamp with time zone,-- 公開日時
    archived_at     timestamp with time zone,-- アーカイブ日時
    position        integer                  not null default 1
);
create unique index uk_event_editions_event_series_id_name on event_editions (event_series_id, name);
create index idx_event_editions_event_series_id on event_editions (event_series_id);
create index idx_event_editions_start_date on event_editions (start_date);
create index idx_event_editions_end_date on event_editions (end_date);
create index idx_event_editions_published_at on event_editions (published_at);
create index idx_event_editions_archived_at on event_editions (archived_at);
create index idx_event_editions_position on event_editions (position);
comment on table event_editions is 'イベントシリーズの特定開催回(例: コミケ〇〇回)を管理';
comment on column event_editions.id is 'イベント開催回ID';
comment on column event_editions.created_at is '作成日時';
comment on column event_editions.updated_at is '更新日時';
comment on column event_editions.event_series_id is 'イベントシリーズID';
comment on column event_editions.name is '管理名';
comment on column event_editions.display_name is '表示名';
comment on column event_editions.slug is 'スラッグ';
comment on column event_editions.start_date is '開始日';
comment on column event_editions.end_date is '終了日';
comment on column event_editions.description is '説明';
comment on column event_editions.note is '備考';
comment on column event_editions.url is 'URL';
comment on column event_editions.twitter_url is 'Twitter URL';
comment on column event_editions.published_at is '公開日時';
comment on column event_editions.archived_at is 'アーカイブ日時';

-- イベント日程テーブル: イベント開催回の中での特定日（例: 3日開催なら各日ごとに記録）
create table event_days (
    id               uuid                     not null primary key default gen_random_uuid(),
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp,
    event_edition_id uuid                     not null references event_editions(id) on delete cascade,
    day_number       integer, -- イベント中の何日目か（1日目=1,2日目=2など）
    display_name     text,    -- 日程表示名（"1日目"、"Day 1"など）
    event_date       date,    -- 実際の開催日付
    region_code      text     not null default 'JP', -- 開催地域コード
    is_cancelled     boolean  not null default false, -- 中止フラグ
    is_online        boolean  not null default false, -- オンライン開催フラグ
    description      text,                           -- 日ごとの説明
    note             text,                           -- メモ
    published_at     timestamp with time zone,       -- 公開日時
    archived_at      timestamp with time zone,       -- アーカイブ日時
    position         integer not null default 1
);
create unique index uk_event_days_event_edition_id_day_number_is_online on event_days (event_edition_id, day_number, is_online);
create index idx_event_days_event_edition_id on event_days (event_edition_id);
create index idx_event_days_event_date on event_days (event_date);
create index idx_event_days_region_code on event_days (region_code);
create index idx_event_days_is_cancelled on event_days (is_cancelled);
create index idx_event_days_is_online on event_days (is_online);
create index idx_event_days_published_at on event_days (published_at);
create index idx_event_days_archived_at on event_days (archived_at);
create index idx_event_days_position on event_days (position);
comment on table event_days is 'イベント開催回内の日程（複数日開催の場合など）を管理';
comment on column event_days.id is 'イベント日程ID';
comment on column event_days.created_at is '作成日時';
comment on column event_days.updated_at is '更新日時';
comment on column event_days.event_edition_id is 'イベント開催回ID';
comment on column event_days.day_number is '日程の順序';
comment on column event_days.display_name is '表示名';
comment on column event_days.event_date is '開催日';
comment on column event_days.region_code is '地域コード オンラインの場合はGlobal/default: JP';
comment on column event_days.is_cancelled is '中止か否か';
comment on column event_days.is_online is 'オンライン開催か否か';
comment on column event_days.description is '説明';
comment on column event_days.note is '備考';
comment on column event_days.published_at is '公開日時';
comment on column event_days.archived_at is 'アーカイブ日時';
comment on column event_days.position is '順序';

create type first_character_type as enum (
    'symbol',   -- 記号
    'number',   -- 数字
    'alphabet', -- 英字
    'hiragana', -- ひらがな
    'katakana', -- カタカナ
    'kanji',    -- 漢字
    'other'     -- その他
);

-- アーティスト本体テーブル: アーティストの基本情報（IDと管理名程度）
create table artists (
    id          uuid                     not null primary key default gen_random_uuid(),
    created_at  timestamp with time zone not null default current_timestamp,
    updated_at  timestamp with time zone not null default current_timestamp,
    name        text not null, -- 開発・管理用の内部名
    note        text           -- 補足情報
);
comment on table artists is 'アーティスト本体。名義はartist_namesで細かく管理';
comment on column artists.id is 'アーティストID';
comment on column artists.created_at is '作成日時';
comment on column artists.updated_at is '更新日時';
comment on column artists.name is '管理名';
comment on column artists.note is '備考';

-- artist_namesテーブル: 本名義・別名義含むアーティスト名情報を管理
-- 複数の名義を持つアーティストもここで統合管理し、本名義はis_main_name=trueで表現
create table artist_names (
    id                    uuid                     not null primary key default gen_random_uuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    artist_id             uuid                     not null references artists(id) on delete cascade,
    name                  text                     not null, -- 名義
    name_reading          text,                    -- 名義読み方
    is_main_name          boolean                  not null default false, -- 本名義フラグ
    first_character_type  first_character_type     not null, -- 名義の頭文字種別（記号、数字、英字、かな等）
    first_character       text,                    -- 頭文字詳細 (英字、ひらがな、カタカナの場合のみ)
    first_character_row   text,                    -- 頭文字の行 (ひらがな、カタカナの場合のみ)
    description           text,                    -- 名義に関する説明文
    note                  text,                    -- メモ
    published_at          timestamp with time zone,-- この名義の公開日時
    archived_at           timestamp with time zone,-- この名義のアーカイブ日時
    check (
        (first_character_type in ('alphabet', 'hiragana', 'katakana') and first_character is not null) or
        (first_character_type not in ('alphabet', 'hiragana', 'katakana') and first_character is null)
    ),
    check (
        (first_character_type in ('hiragana', 'katakana') and first_character_row is not null) or
        (first_character_type not in ('hiragana', 'katakana') and first_character_row is null)
    )
);
create unique index uk_artist_names_artist_id_main_name on artist_names (artist_id, is_main_name) where is_main_name = true;
create index idx_artist_names_artist_id on artist_names (artist_id);
create index idx_artist_names_first_character_type on artist_names (first_character_type);
create index idx_artist_names_first_character on artist_names (first_character_type, first_character);
create index idx_artist_names_published_at on artist_names (published_at);
create index idx_artist_names_archived_at on artist_names (archived_at);
comment on table artist_names is 'アーティストの本名義・別名義を一元管理するテーブル';
comment on column artist_names.id is 'アーティスト名ID';
comment on column artist_names.created_at is '作成日時';
comment on column artist_names.updated_at is '更新日時';
comment on column artist_names.artist_id is 'アーティストID';
comment on column artist_names.name is 'アーティストの名義（本名義または別名義）';
comment on column artist_names.name_reading is '名義の読み方';
comment on column artist_names.is_main_name is 'この名義が本名義かどうか(trueの場合、本名義)';
comment on column artist_names.first_character_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column artist_names.first_character is '頭文字詳細(英字、ひらがな、カタカナの場合のみ)';
comment on column artist_names.first_character_row is '頭文字の行 (ひらがな、カタカナの場合のみ)';
comment on column artist_names.description is '説明';
comment on column artist_names.note is '備考';
comment on column artist_names.published_at is '公開日時';
comment on column artist_names.archived_at is 'アーカイブ日時';

-- artist_rolesテーブル: アーティストが果たす役割（作曲者、編曲者、ボーカリスト等）を定義
create table artist_roles (
    id                    uuid primary key default gen_random_uuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text not null unique, -- 役割名(vocalist, composer等)
    description           text, -- 役割の意味説明
    note                  text  -- メモ
);
comment on table artist_roles is 'アーティストが担う役割(作曲/編曲など)を定義するテーブル';
comment on column artist_roles.id is 'アーティスト役割ID';
comment on column artist_roles.created_at is '作成日時';
comment on column artist_roles.updated_at is '更新日時';
comment on column artist_roles.name is '役割名 (vocalist, composer, arranger, rearranger, lyricistなど)';
comment on column artist_roles.description is '役割の説明';
comment on column artist_roles.note is '備考';

-- circlesテーブル: 同人サークル情報を管理（アーティスト類似だが、組織的単位）
create table circles (
    id                    uuid                     not null primary key default gen_random_uuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text                     not null, -- サークル名
    name_reading          text,                    -- 読み方
    slug                  text                     not null unique default gen_random_uuid(), -- 識別用スラッグ
    first_character_type  first_character_type     not null, -- 頭文字種別
    first_character       text,                    -- 頭文字詳細 (英字、ひらがな、カタカナの場合のみ)
    first_character_row   text,                    -- 頭文字の行 (ひらがな、カタカナの場合のみ)
    description           text,                    -- サークル説明
    note                  text,                    -- メモ
    published_at          timestamp with time zone,-- 公開日時
    archived_at           timestamp with time zone,-- アーカイブ日時
    check (
        (first_character_type in ('alphabet', 'hiragana', 'katakana') and first_character is not null) or
        (first_character_type not in ('alphabet', 'hiragana', 'katakana') and first_character is null)
    ),
    check (
        (first_character_type in ('hiragana', 'katakana') and first_character_row is not null) or
        (first_character_type not in ('hiragana', 'katakana') and first_character_row is null)
    )
);
create index idx_circles_first_character_type on circles (first_character_type);
create index idx_circles_first_character on circles (first_character_type, first_character);
create index idx_circles_published_at on circles (published_at);
create index idx_circles_archived_at on circles (archived_at);
comment on table circles is 'サークル情報（同人音楽サークルなど）を管理';
comment on column circles.id is 'サークルID';
comment on column circles.created_at is '作成日時';
comment on column circles.updated_at is '更新日時';
comment on column circles.name is '名前';
comment on column circles.name_reading is '名前読み方';
comment on column circles.slug is 'スラッグ';
comment on column circles.first_character_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column circles.first_character is '頭文字詳細(英字、ひらがな、カタカナの場合のみ)';
comment on column circles.first_character_row is '頭文字の行 (ひらがな、カタカナの場合のみ)';
comment on column circles.description is '説明';
comment on column circles.note is '備考';
comment on column circles.published_at is '公開日時';
comment on column circles.archived_at is 'アーカイブ日時';

-- entity_urlsテーブル: artist_name, circleなどの任意URL(公式、Twitter、YouTube...)を記録
create table entity_urls (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    entity_type  text                     not null check (entity_type in ('artist_name', 'circle')),
    entity_id    uuid                     not null,
    url_type     text                     not null, -- URL種別(official, twitter, youtube等)
    url          text                     not null, -- 実際のURL
    note         text,                    -- メモ
    position     integer not null default 1
);
create index idx_entity_urls_entity_type_entity_id on entity_urls (entity_type, entity_id);
create index idx_entity_urls_url_type on entity_urls (url_type);
comment on table entity_urls is 'アーティスト名やサークルに紐づく任意のURLを柔軟に格納するテーブル';
comment on column entity_urls.id is 'エンティティURL ID';
comment on column entity_urls.created_at is '作成日時';
comment on column entity_urls.updated_at is '更新日時';
comment on column entity_urls.entity_type is 'エンティティ種別(artist_name, circleなど)';
comment on column entity_urls.entity_id is 'エンティティID';
comment on column entity_urls.url_type is 'URL種別(例: official, twitter, youtube, blogなど)';
comment on column entity_urls.url is 'URL';
comment on column entity_urls.note is '備考';
comment on column entity_urls.position is '順序';

-- albumsテーブル: アレンジCDなど、東方アレンジアルバムを管理
-- イベント頒布日やサークル情報、紹介文などがここに収まる
create table albums (
    id                    uuid                     not null primary key default gen_random_uuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text                     not null, -- アルバム名
    name_reading          text,                    -- 読み方
    slug                  text                     not null unique default gen_random_uuid(),
    release_circle_id     uuid references circles(id) on delete restrict,      -- 頒布主体サークルID（NULL可、ある場合はcircles.id参照）
    release_circle_name   text,                    -- 頒布主体サークル名（テキストで記録）
    release_date          date,                    -- 頒布日
    release_year          integer,                 -- 頒布年
    release_month         integer,                 -- 頒布月
    event_day_id          uuid references event_days(id) on delete set null,    -- 頒布イベント日程ID（NULL可、ある場合はevent_days.id参照）
    album_number          text,                    -- アルバムカタログ番号等
    credit                text,                    -- クレジット情報
    introduction          text,                    -- 短い紹介文
    description           text,                    -- 詳細説明
    note                  text,                    -- メモ
    url                   text,                    -- アルバム公式URL
    published_at          timestamp with time zone,-- 公開日時
    archived_at           timestamp with time zone,-- アーカイブ日時
    position              integer                  not null default 1
);
create index idx_albums_release_circle_id on albums (release_circle_id);
create index idx_albums_release_date on albums (release_date);
create index idx_albums_release_year on albums (release_year);
create index idx_albums_release_month on albums (release_month);
create index idx_albums_release_year_month on albums (release_year, release_month);
create index idx_albums_event_day_id on albums (event_day_id);
create index idx_albums_published_at on albums (published_at);
create index idx_albums_archived_at on albums (archived_at);
create index idx_albums_position on albums (position);
comment on table albums is '東方アレンジアルバム情報を管理';
comment on column albums.id is 'アルバムID';
comment on column albums.created_at is '作成日時';
comment on column albums.updated_at is '更新日時';
comment on column albums.name is '名前';
comment on column albums.name_reading is '名前読み方';
comment on column albums.slug is 'スラッグ';
comment on column albums.release_circle_id is '頒布サークルID';
comment on column albums.release_circle_name is '頒布サークル名';
comment on column albums.release_date is '頒布日';
comment on column albums.release_year is '頒布年';
comment on column albums.release_month is '頒布月';
comment on column albums.event_day_id is 'イベント日程ID';
comment on column albums.credit is 'クレジット';
comment on column albums.introduction is '紹介';
comment on column albums.description is '説明';
comment on column albums.note is '備考';
comment on column albums.url is 'URL';
comment on column albums.published_at is '公開日時';
comment on column albums.archived_at is 'アーカイブ日時';
comment on column albums.position is '順序';

create table albums_circles (
    id          uuid primary key default gen_random_uuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   uuid                     not null references albums(id) on delete cascade,
    circle_id  uuid                     not null references circles(id) on delete cascade,
    position   integer                  not null default 1
);
create unique index uk_albums_circles_album_id_circle_id on albums_circles (album_id, circle_id);
create index idx_albums_circles_album_id on albums_circles (album_id);
create index idx_albums_circles_circle_id on albums_circles (circle_id);
create index idx_albums_circles_position on albums_circles (position);
comment on table albums_circles is 'アルバムとサークルを関連付ける中間テーブル（1枚のアルバムに複数サークルが関与するケースをサポート）';
comment on column albums_circles.id is 'アルバムとサークルの中間テーブルのID';
comment on column albums_circles.created_at is '作成日時';
comment on column albums_circles.updated_at is '更新日時';
comment on column albums_circles.album_id is '関与するアルバムのID';
comment on column albums_circles.circle_id is '関与するサークルのID';
comment on column albums_circles.position is '複数サークルが関わる場合の表示順序';

/* create type shop as enum (
    'akiba_hobby',    -- AKIBA-HOBBY
    'akibaoo',        -- あきばお～
    'animate',        -- アニメイト
    'bookmate',       -- ブックメイト
    'booth',          -- BOOTH
    'diverse_direct', -- Diverse Direct
    'grep',           -- グレップ
    'melonbooks',     -- メロンブックス
    'tanocstore',     -- TANO*C STORE
    'toranoana'       -- とらのあな
); */

create table shops (
    id           uuid primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    name         text not null unique,
    display_name text not null,
    description  text,
    note         text,
    website_url  text,
    base_urls    jsonb,
    published_at timestamp with time zone,
    archived_at  timestamp with time zone,
    position     integer not null default 1
);
create index idx_shops_published_at on shops (published_at);
create index idx_shops_archived_at on shops (archived_at);
create index idx_shops_position on shops (position);
comment on table shops is 'CDや関連グッズを扱う各ショップ(販売店/同人ショップ)の情報を管理';
comment on column shops.id is 'ショップID';
comment on column shops.created_at is '作成日時';
comment on column shops.updated_at is '更新日時';
comment on column shops.name is '内部システムで用いるショップの識別名(ユニーク)';
comment on column shops.display_name is '表示用のショップ名（ユーザーや外部表示用）';
comment on column shops.description is 'ショップの説明';
comment on column shops.note is '備考';
comment on column shops.website_url is '公式サイトURL（ユーザーがアクセス可能なURL）';
comment on column shops.base_urls is 'このショップに関連するベースURLリスト(json形式)';
comment on column shops.published_at is '公開日時';
comment on column shops.archived_at is 'アーカイブ日時';
comment on column shops.position is '順序';

-- album_pricesテーブル: アルバムの販売価格やイベント頒布価格、ショップ価格を管理
-- 無料頒布はis_free=trueでprice=0、event/shopの区別はprice_typeで行う
create table album_prices (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    album_id     uuid                     not null references albums(id) on delete cascade,
    price_type   text                     not null check (price_type in ('event', 'shop')), -- イベント価格/ショップ価格
    is_free      boolean                  not null default false, -- 無料頒布フラグ
    price        numeric                  not null,               -- 価格
    currency     text                     not null default 'JPY', -- 通貨
    tax_included boolean                  not null default false,  -- 税込みか否か
    shop_id      uuid references shops(id) on delete restrict,  -- NULL許可だが、値があればshops(id)を参照して整合性確保
    url          text,                                           -- 販売URL
    description  text,                                           -- 価格に関する説明（特別価格等）
    note         text,                                           -- メモ
    position     integer                  not null default 1,
    check(
        (is_free = true and price = 0)
        or (is_free = false and price > 0)
    )
);
create unique index uk_ap_album_id_shop_id on album_prices (album_id, shop_id);
create index idx_album_prices_album_id on album_prices (album_id);
create index idx_album_prices_shop_id on album_prices (shop_id);
create index idx_album_prices_price_type on album_prices (price_type);
create index idx_album_prices_album_id_price_type on album_prices (album_id, price_type);
create index idx_album_prices_shop_id_price_type on album_prices (shop_id, price_type);
create index idx_album_prices_position on album_prices (position);
comment on table album_prices is 'アルバム価格情報を管理（イベント価格、ショップ価格、無料頒布など）';
comment on column album_prices.id is 'アルバム価格のID';
comment on column album_prices.created_at is '作成日時';
comment on column album_prices.updated_at is '更新日時';
comment on column album_prices.album_id is 'アルバムID';
comment on column album_prices.price_type is '価格の種類(event: イベント価格, shop: 通常価格)';
comment on column album_prices.is_free is '無料頒布有無(true: 無料頒布, false: 有料頒布)';
comment on column album_prices.price is '価格';
comment on column album_prices.currency is '通貨(default: JPY)';
comment on column album_prices.tax_included is '税込みか否か(true: 税込み、false: 税抜き・税別)';
comment on column album_prices.shop_id is 'ショップID（NULL可、ある場合はshopsテーブルを参照）';
comment on column album_prices.url is 'URL';
comment on column album_prices.description is '説明';
comment on column album_prices.note is '備考';
comment on column album_prices.position is '順序';

create table album_upcs (
    id         uuid                     not null primary key default gen_random_uuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   uuid                     not null references albums(id) on delete cascade,
    upc        text                     not null,
    position   integer                  not null default 1
);
create unique index uk_album_upcs_album_id_upc on album_upcs (album_id, upc);
create index idx_album_upcs_album_id on album_upcs (album_id);
create index idx_album_upcs_position on album_upcs (position);
comment on table album_upcs is 'アルバムに付与されるUPC(JAN)コードを管理するテーブル（商品バーコード情報）';
comment on column album_upcs.id is 'アルバムUPCのID';
comment on column album_upcs.created_at is '作成日時';
comment on column album_upcs.updated_at is '更新日時';
comment on column album_upcs.album_id is 'アルバムID';
comment on column album_upcs.upc is 'アルバムに割り当てられたUPC(JAN)コード(バーコード)';
comment on column album_upcs.position is '複数UPCがある場合の並び順';

create table album_discs (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    album_id     uuid                     not null references albums(id) on delete cascade,
    disc_number  integer,
    name         text,
    description  text,
    note         text,
    position     integer                  not null default 1
);
create index idx_album_discs_album_id on album_discs (album_id);
create index idx_album_discs_disc_number on album_discs (disc_number);
create index idx_album_discs_position on album_discs (position);
comment on table album_discs is 'アルバムが複数ディスクで構成される場合に各ディスクの情報（番号、名称、説明）を管理するテーブル';
comment on column album_discs.id is 'アルバムディスクID';
comment on column album_discs.created_at is '作成日時';
comment on column album_discs.updated_at is '更新日時';
comment on column album_discs.album_id is 'アルバムID';
comment on column album_discs.disc_number is 'ディスクの通し番号（1枚目=1、2枚目=2など）';
comment on column album_discs.name is 'ディスク名（必要な場合）';
comment on column album_discs.description is 'ディスクに関する説明（例: ボーナスディスクの詳細など）';
comment on column album_discs.note is '備考';
comment on column album_discs.position is '順序';

create table songs (
    id                    uuid                     not null primary key default gen_random_uuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    circle_id             uuid references circles(id) on delete restrict,      -- NULL可だが値があればcircles(id)を参照
    album_id              uuid references albums(id) on delete restrict,       -- NULL可、あればalbums(id)参照
    name                  text                     not null,
    name_reading          text,
    release_date          date,
    release_year          integer,
    release_month         integer,
    slug                  text                     not null unique default gen_random_uuid(),
    album_disc_id         uuid references album_discs(id) on delete set null,  -- NULL可、あればalbum_discs(id)参照
    disc_number           integer,
    track_number          integer,
    length_time_ms        integer,
    bpm                   integer,
    description           text,
    note                  text,
    display_composer      text,
    display_arranger      text,
    display_rearranger    text,
    display_lyricist      text,
    display_vocalist      text,
    display_original_song text,
    published_at          timestamp with time zone,
    archived_at           timestamp with time zone,
    position              integer not null default 1
);
create index idx_songs_circle_id on songs (circle_id);
create index idx_songs_album_id on songs (album_id);
create index idx_songs_release_date on songs (release_date);
create index idx_songs_release_year on songs (release_year);
create index idx_songs_release_month on songs (release_month);
create index idx_songs_release_year_month on songs (release_year, release_month);
create index idx_songs_published_at on songs (published_at);
create index idx_songs_archived_at on songs (archived_at);
create index idx_songs_position on songs (position);
comment on table songs is '楽曲情報を管理するテーブル（アルバム収録曲や単独頒布曲などの基本情報）';
comment on column songs.id is '楽曲ID';
comment on column songs.created_at is '作成日時';
comment on column songs.updated_at is '更新日時';
comment on column songs.circle_id is 'サークルID（NULL可、あればcirclesテーブル参照）';
comment on column songs.album_id is 'アルバムID（NULL可、あればalbumsテーブル参照）';
comment on column songs.name is '楽曲名（正式タイトル）';
comment on column songs.name_reading is '名前読み方';
comment on column songs.release_date is '頒布日(アルバムの頒布日と異なる場合に使用する)';
comment on column songs.release_year is '頒布年';
comment on column songs.release_month is '頒布月';
comment on column songs.slug is 'URLなどで使用する一意識別子（ランダム生成された文字列）';
comment on column songs.album_disc_id is 'アルバムディスクID（NULL可、あればalbum_discsテーブル参照）';
comment on column songs.disc_number is 'ディスク番号';
comment on column songs.track_number is 'トラック番号';
comment on column songs.length_time_ms is '曲の長さ(ミリ秒)';
comment on column songs.bpm is 'BPM';
comment on column songs.description is '楽曲に関する説明文（特徴、背景、解説など）';
comment on column songs.note is 'メモや補足情報（内部用、注釈など）';
comment on column songs.display_composer is '特定条件下で表示する作曲者名（メイン以外の名義など）';
comment on column songs.display_arranger is '特定条件下で表示する編曲者名（メイン以外の名義など）';
comment on column songs.display_rearranger is '再編曲者表示名（別名義など特例的な表示用）';
comment on column songs.display_lyricist is '特定条件下で表示する作詞者名';
comment on column songs.display_vocalist is '特定条件下で表示するボーカリスト名';
comment on column songs.display_original_song is '原曲表示用（東方以外や特殊な原曲を示す際に使用）';
comment on column songs.published_at is '公開日時';
comment on column songs.archived_at is 'アーカイブ日時';
comment on column songs.position is '順序';

create table song_lyrics (
    id          uuid                     not null primary key default gen_random_uuid(),
    created_at  timestamp with time zone not null default current_timestamp,
    updated_at  timestamp with time zone not null default current_timestamp,
    song_id     uuid                     not null references songs(id) on delete cascade,
    content     text                     not null,
    language    text                              default 'ja', -- 言語を指定。デフォルトは日本語
    description text,
    note        text,
    position    integer not null default 1
);
create index idx_song_lyrics_song_id on song_lyrics (song_id);
create index idx_song_lyrics_position on song_lyrics (position);
comment on table song_lyrics is '楽曲に対応する歌詞情報を管理するテーブル';
comment on column song_lyrics.id is '歌詞ID';
comment on column song_lyrics.created_at is '作成日時';
comment on column song_lyrics.updated_at is '更新日時';
comment on column song_lyrics.song_id is '楽曲ID';
comment on column song_lyrics.content is '歌詞本文';
comment on column song_lyrics.language is '歌詞の言語コード（例: "ja" = 日本語）';
comment on column song_lyrics.description is 'この歌詞に関する説明（翻訳元やバージョン違いの説明など）';
comment on column song_lyrics.note is '備考';
comment on column song_lyrics.position is '楽曲が持つ歌詞の順序';

create table song_bmps (
    id            uuid                     not null primary key default gen_random_uuid(),
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp,
    song_id       uuid                     not null references songs(id) on delete cascade,
    bpm           integer                  not null,
    start_time_ms bigint,
    end_time_ms   bigint,
    position      integer not null default 1
);
create index idx_song_bmps_song_id on song_bmps (song_id);
create index idx_song_bmps_position on song_bmps (position);
comment on table song_bmps is '楽曲内でのBPM情報（BPM変化箇所）を管理するテーブル';
comment on column song_bmps.id is '楽曲BPMのID';
comment on column song_bmps.created_at is '作成日時';
comment on column song_bmps.updated_at is '更新日時';
comment on column song_bmps.song_id is '楽曲ID';
comment on column song_bmps.bpm is 'BPM値（1分あたりのビート数）';
comment on column song_bmps.start_time_ms is 'このBPMが適用される開始時刻(ミリ秒)';
comment on column song_bmps.end_time_ms is 'このBPMが適用される終了時刻(ミリ秒)';
comment on column song_bmps.position is '楽曲が持つBPMの順序';

create table song_isrcs (
    id         uuid                     not null primary key default gen_random_uuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    uuid                     not null references songs(id) on delete cascade,
    isrc       text                     not null,
    position   integer not null default 1
);
create unique index uk_song_isrcs_song_id_isrc on song_isrcs (song_id, isrc);
create index idx_song_isrcs_song_id on song_isrcs (song_id);
create index idx_song_isrcs_position on song_isrcs (position);
comment on table song_isrcs is '楽曲に対応するISRC(国際標準レコーディングコード)を管理するテーブル';
comment on column song_isrcs.id is '楽曲ISRCのID';
comment on column song_isrcs.created_at is '作成日時';
comment on column song_isrcs.updated_at is '更新日時';
comment on column song_isrcs.song_id is '楽曲ID';
comment on column song_isrcs.isrc is 'ISRCコード（世界共通の音源識別子）';
comment on column song_isrcs.position is '楽曲が持つISRCの順序';

create table songs_arrange_circles (
    id         uuid                     not null primary key default gen_random_uuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    uuid                     not null references songs(id) on delete cascade,
    circle_id  uuid                     not null references circles(id) on delete cascade,
    position   integer not null default 1
);
create unique index uk_songs_arrange_circles_song_id_circle_id on songs_arrange_circles (song_id, circle_id);
create index idx_songs_arrange_circles_song_id on songs_arrange_circles (song_id);
create index idx_songs_arrange_circles_circle_id on songs_arrange_circles (circle_id);
create index idx_songs_arrange_circles_position on songs_arrange_circles (position);
comment on table songs_arrange_circles is '楽曲の編曲に関わったサークルを関連付けるテーブル（複数サークルが関与する場合に対応）';
comment on column songs_arrange_circles.id is '楽曲編曲サークルID';
comment on column songs_arrange_circles.created_at is '作成日時';
comment on column songs_arrange_circles.updated_at is '更新日時';
comment on column songs_arrange_circles.song_id is '楽曲ID';
comment on column songs_arrange_circles.circle_id is '編曲に関わったサークルID';
comment on column songs_arrange_circles.position is '編曲サークルが楽曲に対して持つ順序';

create table songs_original_songs (
    id               uuid                     not null primary key default gen_random_uuid(),
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp,
    song_id          uuid                     not null references songs(id) on delete cascade,
    original_song_id text                     not null references original_songs(id) on delete cascade,
    position         integer not null default 1
);
create unique index uk_songs_original_songs_song_id_original_song_id on songs_original_songs (song_id, original_song_id);
create index idx_songs_original_songs_song_id on songs_original_songs (song_id);
create index idx_songs_original_songs_original_song_id on songs_original_songs (original_song_id);
create index idx_songs_original_songs_position on songs_original_songs (position);
comment on table songs_original_songs is '楽曲と原曲の関連付けテーブル。1つの楽曲が複数の原曲を元にしている場合に対応可能';
comment on column songs_original_songs.id is '楽曲原曲ID';
comment on column songs_original_songs.created_at is '作成日時';
comment on column songs_original_songs.updated_at is '更新日時';
comment on column songs_original_songs.song_id is '楽曲ID';
comment on column songs_original_songs.original_song_id is '元になった原曲ID（original_songsテーブル参照）';
comment on column songs_original_songs.position is '楽曲が原曲に対して持つ順序';

create table songs_artist_roles (
    id             uuid primary key default gen_random_uuid(),  -- UUIDを生成
    created_at     timestamp with time zone not null default current_timestamp,
    updated_at     timestamp with time zone not null default current_timestamp,
    song_id        uuid                     not null references songs(id) on delete cascade,        -- 楽曲ID
    artist_name_id uuid                     not null references artist_names(id) on delete cascade, -- アーティスト名ID (本名義または別名義) 
    artist_role_id uuid                     not null references artist_roles(id) on delete cascade, -- 役割ID（artist_rolesテーブルを参照）
    connector      text,                                       -- アーティスト名と結合するための接続詞（例: "vs", "feat."）
    position       integer not null default 1                   -- アーティストが曲に参加する順序
);
create unique index uk_sar_song_id_artist_name_id_artist_role_id on songs_artist_roles (song_id, artist_name_id, artist_role_id);
create index idx_songs_artist_roles_song_id on songs_artist_roles (song_id);
create index idx_songs_artist_roles_artist_name_id on songs_artist_roles (artist_name_id);
create index idx_songs_artist_roles_artist_role_id on songs_artist_roles (artist_role_id);
create index idx_songs_artist_roles_position on songs_artist_roles (position);
comment on table songs_artist_roles is '楽曲に参加するアーティストの名義と役割（作曲、編曲、ボーカルなど）を関連付けるテーブル';
comment on column songs_artist_roles.id is '主キーID';
comment on column songs_artist_roles.created_at is '作成日時';
comment on column songs_artist_roles.updated_at is '更新日時';
comment on column songs_artist_roles.song_id is '楽曲ID';
comment on column songs_artist_roles.artist_name_id is 'アーティスト名ID（artist_namesテーブル参照、本名義・別名義を含む）';
comment on column songs_artist_roles.artist_role_id is '役割ID（artist_rolesテーブル参照）';
comment on column songs_artist_roles.connector is 'アーティスト名同士を結ぶ接続詞（"vs"、"feat."など）';
comment on column songs_artist_roles.position is 'アーティストが曲に参加する順序';

create table genres (
    id          uuid                     not null primary key default gen_random_uuid(),
    created_at  timestamp with time zone not null default current_timestamp,
    updated_at  timestamp with time zone not null default current_timestamp,
    name        text                     not null unique,
    description text,
    note        text
);
comment on table genres is 'ジャンル情報を管理するテーブル（ロック、ジャズ、エレクトロなど）';
comment on column genres.id is 'ジャンルID';
comment on column genres.created_at is '作成日時';
comment on column genres.updated_at is '更新日時';
comment on column genres.name is 'ジャンル名（ユニーク）';
comment on column genres.description is 'ジャンルの簡易説明';
comment on column genres.note is 'ジャンルに関する補足情報';

create table tags (
    id          uuid                     not null primary key default gen_random_uuid(),
    created_at  timestamp with time zone not null default current_timestamp,
    updated_at  timestamp with time zone not null default current_timestamp,
    name        text                     not null unique,
    description text,
    note        text
);
comment on table tags is 'タグ情報を管理するテーブル。ジャンル以外の属性や特徴を自由に付与可能';
comment on column tags.id is 'タグID';
comment on column tags.created_at is '作成日時';
comment on column tags.updated_at is '更新日時';
comment on column tags.name is 'タグ名（ユニーク）';
comment on column tags.description is 'タグに関する説明文';
comment on column tags.note is 'タグに関する補足情報';

create table songs_genres (
    id            uuid                     not null primary key default gen_random_uuid(),
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp,
    song_id       uuid                     not null references songs(id) on delete cascade,
    genre_id      uuid                     not null references genres(id) on delete cascade,
    start_time_ms bigint,
    end_time_ms   bigint,
    locked_at     timestamp with time zone,
    position      integer not null default 1
);
create index idx_songs_genres_song_id_genre_id on songs_genres (song_id, genre_id);
create index idx_songs_genres_song_id on songs_genres (song_id);
create index idx_songs_genres_genre_id on songs_genres (genre_id);
create index idx_songs_genres_locked_at on songs_genres (locked_at);
create index idx_songs_genres_position on songs_genres (position);
comment on table songs_genres is '楽曲に紐づくジャンル情報を管理する中間テーブル（開始位置・終了位置で曲中の特定区間を示すことも可能）';
comment on column songs_genres.id is '楽曲ジャンルID';
comment on column songs_genres.created_at is '作成日時';
comment on column songs_genres.updated_at is '更新日時';
comment on column songs_genres.song_id is '楽曲ID';
comment on column songs_genres.genre_id is 'ジャンルID';
comment on column songs_genres.start_time_ms is 'このジャンルが適用される楽曲内の開始時刻(ミリ秒)';
comment on column songs_genres.end_time_ms is 'このジャンルが適用される楽曲内の終了時刻(ミリ秒)';
comment on column songs_genres.locked_at is 'ジャンル情報を固定する日時（再編集不可などの運用制約に使用）';
comment on column songs_genres.position is '楽曲が持つジャンルの順序';

create table entity_genres (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    entity_type  text                     not null check (entity_type in ('Album', 'Circle', 'Artist')),
    entity_id    uuid                     not null,
    genre_id     uuid                     not null references genres(id) on delete cascade,
    locked_at    timestamp with time zone,
    position     integer not null default 1
);
create unique index uk_entity_genres_entity_type_entity_id_genre_id on entity_genres (entity_type, entity_id, genre_id);
create index idx_entity_genres_locked_at on entity_genres (locked_at);
create index idx_entity_genres_position on entity_genres (position);
comment on table entity_genres is 'アルバム、サークル、アーティストなどにジャンルを割り当てる中間テーブル';
comment on column entity_genres.id is 'エンティティジャンルID';
comment on column entity_genres.created_at is '作成日時';
comment on column entity_genres.updated_at is '更新日時';
comment on column entity_genres.entity_type is '対象エンティティ種別（Album, Circle, Artistのいずれか）';
comment on column entity_genres.entity_id is 'エンティティのID（アルバムID、サークルID、アーティストID）';
comment on column entity_genres.genre_id is '割り当てるジャンルID';
comment on column entity_genres.locked_at is 'ジャンル付与情報をロックする日時';

create table entity_tags (
    id           uuid                     not null primary key default gen_random_uuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    entity_type  text                     not null check (entity_type in ('Album', 'Song', 'Circle', 'Artist')),
    entity_id    uuid                     not null,
    tag_id       uuid                     not null references tags(id) on delete cascade,
    locked_at    timestamp with time zone
);
create unique index uk_entity_tags_entity_type_entity_id_tag_id on entity_tags (entity_type, entity_id, tag_id);
create index idx_entity_tags_locked_at on entity_tags (locked_at);
comment on table entity_tags is 'アルバム、楽曲、サークル、アーティストなど任意のエンティティにタグを付ける中間テーブル';
comment on column entity_tags.id is 'エンティティタグID';
comment on column entity_tags.created_at is '作成日時';
comment on column entity_tags.updated_at is '更新日時';
comment on column entity_tags.entity_type is '対象エンティティ種別（Album, Song, Circle, Artist）';
comment on column entity_tags.entity_id is 'エンティティのID（アルバムID、楽曲ID、サークルID、アーティストID）';
comment on column entity_tags.tag_id is '付与するタグID';
comment on column entity_tags.locked_at is 'タグ付与情報をロックする日時';

-- migrate:down

-- テーブルの削除は依存関係のある順序で実行
drop table if exists entity_tags cascade;
drop table if exists entity_genres cascade;
drop table if exists songs_genres cascade;
drop table if exists songs_artist_roles cascade;
drop table if exists songs_original_songs cascade;
drop table if exists songs_arrange_circles cascade;
drop table if exists song_isrcs cascade;
drop table if exists song_bmps cascade;
drop table if exists song_lyrics cascade;
drop table if exists songs cascade;
drop table if exists album_discs cascade;
drop table if exists album_upcs cascade;
drop table if exists album_prices cascade;
drop table if exists albums_circles cascade;
drop table if exists albums cascade;
drop table if exists entity_urls cascade;
drop table if exists circles cascade;
drop table if exists artist_roles cascade;
drop table if exists artist_names cascade;
drop table if exists artists cascade;
drop table if exists event_days cascade;
drop table if exists event_editions cascade;
drop table if exists event_series cascade;
drop table if exists distribution_service_urls cascade;
drop table if exists distribution_services cascade;
drop table if exists original_songs cascade;
drop table if exists products cascade;

-- 型を削除
drop type if exists first_character_type cascade;
drop type if exists product_type cascade;
