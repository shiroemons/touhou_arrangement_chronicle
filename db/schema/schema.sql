create type product_type as enum (
    'pc98',
    'windows',
    'zuns_music_collection',
    'akyus_untouched_score',
    'commercial_books',
    'tasofro',
    'other'
);

create table products (
    id            text                     not null primary key,
    name          text                     not null,
    short_name    text                     not null,
    product_type  product_type             not null,
    series_number numeric(5,2)             not null,
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp
);
comment on table  products is '原作';
comment on column products.id is '原作ID';
comment on column products.name is '名前';
comment on column products.short_name is '短い名前';
comment on column products.product_type is '原作種別';
comment on column products.series_number is 'シリーズ番号';
comment on column products.created_at is '作成日時';
comment on column products.updated_at is '更新日時';

create table original_songs (
    id           text                     not null primary key,
    product_id   text                     not null references products(id),
    name         text                     not null,
    composer     text                     not null default '',
    arranger     text                     not null default '',
    track_number integer                  not null,
    is_original  boolean                  not null default false,
    source_id    text                     not null default '',
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp
);
comment on table  original_songs is '原曲';
comment on column original_songs.product_id is '原作ID';
comment on column original_songs.id is '原曲ID';
comment on column original_songs.name is '名前';
comment on column original_songs.composer is '作曲者';
comment on column original_songs.arranger is '編曲者';
comment on column original_songs.track_number is 'トラック番号';
comment on column original_songs.is_original is 'オリジナル有無(true: オリジナル(初出)、false: 再録など)';
comment on column original_songs.source_id is '原曲元の原曲ID';
comment on column original_songs.created_at is '作成日時';
comment on column original_songs.updated_at is '更新日時';

create type distribution_service as enum (
    'spotify',
    'apple_music',
    'youtube_music',
    'line_music',
    'itunes',
    'youtube',
    'nicovideo',
    'sound_cloud'
);

create table product_distribution_service_urls (
    id           text                     not null primary key,
    product_id   text                     not null references products(id),
    service      distribution_service     not null,
    url          text                     not null,
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp
);
create unique index uk_pdsu_product_id_service on product_distribution_service_urls (product_id, service);
comment on table  product_distribution_service_urls is '原作(音楽)配信サービスURL';
comment on column product_distribution_service_urls.product_id is '原作ID';
comment on column product_distribution_service_urls.service is '配信サービス';
comment on column product_distribution_service_urls.url is 'URL';
comment on column product_distribution_service_urls.created_at is '作成日時';
comment on column product_distribution_service_urls.updated_at is '更新日時';

create table original_song_distribution_service_urls (
    id               text                     not null primary key,
    original_song_id text                     not null references original_songs(id),
    service          distribution_service     not null,
    url              text                     not null,
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp
);
create unique index uk_osdsu_original_song_id_service on original_song_distribution_service_urls (original_song_id, service);
comment on table  original_song_distribution_service_urls is '原曲配信サービスURL';
comment on column original_song_distribution_service_urls.original_song_id is '原曲ID';
comment on column original_song_distribution_service_urls.service is '配信サービス';
comment on column original_song_distribution_service_urls.url is 'URL';
comment on column original_song_distribution_service_urls.created_at is '作成日時';
comment on column original_song_distribution_service_urls.updated_at is '更新日時';

create table event_series (
    id           text                     not null primary key,
    name         text                     not null unique,
    display_name text                     not null,
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp
);
comment on table  event_series is 'イベントシリーズ';
comment on column event_series.name is '名前';
comment on column event_series.display_name is '表示名';
comment on column event_series.created_at is '作成日時';
comment on column event_series.updated_at is '更新日時';

create type event_status as enum (
    'scheduled',    -- 開催済み
    'cancelled',    -- 中止
    'postpone',     -- 延期(開催日未定)
    'rescheduled',  -- 延期(開催日決定)
    'moved_online', -- オンライン開催に変更
    'other'         -- その他
);

create type event_format as enum (
    'offline', -- オフライン開催
    'online',  -- オンライン開催
    'mixed'   -- オフライン・オンライン両方開催
);

create table events (
    id              text                     not null primary key,
    event_series_id text                     not null references event_series(id),
    name            text                     not null unique,
    display_name    text                     not null,
    event_dates     daterange,
    event_status    event_status             not null default 'scheduled'::event_status,
    format          event_format             not null default 'offline'::event_format,
    region_code     text                     not null default 'JP',
    address         text                     not null default '',
    description     text                     not null default '',
    url             text                     not null default '',
    twitter_url     text                     not null default '',
    created_at      timestamp with time zone not null default current_timestamp,
    updated_at      timestamp with time zone not null default current_timestamp
);
comment on table  events is 'イベント';
comment on column events.event_series_id is 'イベントシリーズID';
comment on column events.name is '名前';
comment on column events.display_name is '表示名';
comment on column events.event_dates is 'イベント開催期間';
comment on column events.event_status is 'ステータス/scheduled: 開催済み, cancelled: 中止, postpone: 延期(開催日未定), rescheduled: 延期(開催日決定), moved_online: オンライン開催に変更, other: その他/default: scheduled';
comment on column events.format is '形式/offline: オフライン開催, online: オフライン開催, mixed: 両方開催/default: offline';
comment on column events.region_code is 'リージョンコード/default: JP';
comment on column events.address is '開催場所';
comment on column events.description is '説明';
comment on column events.url is 'URL';
comment on column events.twitter_url is 'Twitter URL';
comment on column events.created_at is '作成日時';
comment on column events.updated_at is '更新日時';

create table sub_events (
    id           text                     not null primary key,
    event_id     text                     not null references events(id),
    name         text                     not null,
    display_name text                     not null,
    event_date   date,
    event_status event_status             not null default 'scheduled'::event_status,
    description  text                     not null default '',
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp
);
comment on table  sub_events is 'サブイベント';
comment on column sub_events.event_id is 'イベントID';
comment on column sub_events.name is '名前(例: 〇〇 2日目)';
comment on column sub_events.display_name is '表示名';
comment on column sub_events.event_date is '開催日';
comment on column sub_events.event_status is 'ステータス/scheduled: 開催済み, cancelled: 中止, postpone: 延期(開催日未定), rescheduled: 延期(開催日決定), moved_online: オンライン開催に変更, other: その他/default: scheduled';
comment on column sub_events.description is '説明';
comment on column sub_events.created_at is '作成日時';
comment on column sub_events.updated_at is '更新日時';

create type initial_letter_type as enum (
    'symbol',   -- 記号
    'number',   -- 数字
    'alphabet', -- 英字
    'hiragana', -- ひらがな
    'katakana', -- カタカナ
    'kanji',    -- 漢字
    'other'     -- その他
);

create table artists (
    id                    text                     not null primary key,
    name                  text                     not null,
    name_reading          text                     not null default '',
    initial_letter_type   initial_letter_type      not null,
    initial_letter_detail text                     not null default '',
    description           text                     not null default '',
    url                   text                     not null default '',
    blog_url              text                     not null default '',
    twitter_url           text                     not null default '',
    youtube_channel_url   text                     not null default '',
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp
);
comment on table  artists is 'アーティスト';
comment on column artists.name is '名前';
comment on column artists.name_reading is '名前読み方';
comment on column artists.initial_letter_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column artists.initial_letter_detail is '頭文字の文字種別詳細';
comment on column artists.description is '説明';
comment on column artists.url is 'URL';
comment on column artists.blog_url is 'ブログ URL';
comment on column artists.twitter_url is 'Twitter URL';
comment on column artists.youtube_channel_url is 'YouTubeチャンネル URL';
comment on column artists.created_at is '作成日時';
comment on column artists.updated_at is '更新日時';

create table circles (
    id                    text                     not null primary key,
    name                  text                     not null,
    name_reading          text                     not null default '',
    initial_letter_type   initial_letter_type      not null,
    initial_letter_detail text                     not null,
    description           text                     not null default '',
    url                   text                     not null default '',
    blog_url              text                     not null default '',
    twitter_url           text                     not null default '',
    youtube_channel_url   text                     not null default '',
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp
);
comment on table  circles is 'サークル';
comment on column circles.name is '名前';
comment on column circles.name_reading is '名前読み方';
comment on column circles.initial_letter_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column circles.initial_letter_detail is '頭文字の文字種別詳細';
comment on column circles.description is '説明';
comment on column circles.url is 'URL';
comment on column circles.blog_url is 'ブログ URL';
comment on column circles.twitter_url is 'Twitter URL';
comment on column circles.youtube_channel_url is 'YouTubeチャンネル URL';
comment on column circles.created_at is '作成日時';
comment on column circles.updated_at is '更新日時';

create table albums (
    id                    text                     not null primary key,
    name                  text                     not null,
    release_circle_name   text                     not null default '',
    release_date          date,
    event_id              text                     not null default '',
    sub_event_id          text                     not null default '',
    search_enabled        bool                     not null default true,
    album_number          text                     not null default '',
    event_price           numeric,
    currency              text                     not null default 'JPY',
    credit                text                     not null default '',
    introduction          text                     not null default '',
    url                   text                     not null default '',
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp
);
comment on table  albums is 'アルバム';
comment on column albums.name is '名前';
comment on column albums.release_circle_name is '頒布サークル名';
comment on column albums.release_date is '頒布日';
comment on column albums.event_id is 'イベントID';
comment on column albums.sub_event_id is 'サブイベントID';
comment on column albums.search_enabled is '検索対象とするか';
comment on column albums.event_price is 'イベント価格';
comment on column albums.currency is '通貨(default: JPY)';
comment on column albums.credit is 'クレジット';
comment on column albums.introduction is '紹介';
comment on column albums.url is 'URL';
comment on column albums.created_at is '作成日時';
comment on column albums.updated_at is '更新日時';

create table albums_circles (
    album_id   text                     not null references albums(id),
    circle_id  text                     not null references circles(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (album_id, circle_id)
);
comment on table  albums_circles is 'アルバムとサークルの中間テーブル';
comment on column albums_circles.album_id is 'アルバムID';
comment on column albums_circles.circle_id is 'サークルID';
comment on column albums_circles.created_at is '作成日時';
comment on column albums_circles.updated_at is '更新日時';

create type shop as enum (
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
);

create table album_consignment_shops (
    id           text                     not null primary key,
    album_id     text                     not null references albums(id),
    shop         shop                     not null,
    url          text                     not null,
    tax_included bool                     not null default false,
    shop_price   numeric                  not null,
    currency     text                     not null default 'JPY',
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp
);
comment on table  album_consignment_shops is 'アルバム委託販売ショップ';
comment on column album_consignment_shops.album_id is 'アルバムID';
comment on column album_consignment_shops.shop is 'ショップ';
comment on column album_consignment_shops.url is 'URL';
comment on column album_consignment_shops.tax_included is '税込みか否か(true: 税込み、false: 税抜き・税別)';
comment on column album_consignment_shops.shop_price is 'ショップ価格';
comment on column album_consignment_shops.currency is '通貨(default: JPY)';
comment on column album_consignment_shops.created_at is '作成日時';
comment on column album_consignment_shops.updated_at is '更新日時';

create table album_distribution_service_urls (
    id         text                     not null primary key,
    album_id   text                     not null references albums(id),
    service    distribution_service     not null,
    url        text                     not null,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp
);
comment on table  album_distribution_service_urls is 'アルバム配信サービスURL';
comment on column album_distribution_service_urls.album_id is 'アルバムID';
comment on column album_distribution_service_urls.service is '配信サービス';
comment on column album_distribution_service_urls.url is 'URL';
comment on column album_distribution_service_urls.created_at is '作成日時';
comment on column album_distribution_service_urls.updated_at is '更新日時';

create table album_upcs (
    id         text                     not null primary key,
    album_id   text                     not null references albums(id),
    upc        text                     not null,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp
);
create unique index uk_album_upcs_album_id_upc on album_upcs (album_id, upc);
comment on table  album_upcs is 'アルバムUPC';
comment on column album_upcs.album_id is 'アルバムID';
comment on column album_upcs.upc is 'UPC(JAN)コード';
comment on column album_upcs.created_at is '作成日時';
comment on column album_upcs.updated_at is '更新日時';

create table tracks (
    id                    text                     not null primary key,
    album_id              text                     not null references albums(id),
    name                  text                     not null,
    name_reading          text                     not null default '',
    disc_number           integer                  not null default 1,
    track_number          integer                  not null,
    release_date          date,
    search_enabled        bool                     not null default true,
    length                integer,
    bpm                   integer,
    display_composer      text                     not null default '',
    display_arranger      text                     not null default '',
    display_rearranger    text                     not null default '',
    display_lyricist      text                     not null default '',
    display_vocalist      text                     not null default '',
    display_original_song text                     not null default '',
    created_at     timestamp with time zone not null default current_timestamp,
    updated_at     timestamp with time zone not null default current_timestamp
);
comment on table  tracks is 'トラック';
comment on column tracks.album_id is 'アルバムID';
comment on column tracks.name is '名前';
comment on column tracks.name_reading is '名前読み方';
comment on column tracks.disc_number is 'ディスク番号(default: 1)';
comment on column tracks.track_number is 'トラック番号';
comment on column tracks.release_date is '頒布日(アルバムの頒布日と異なる場合に使用する)';
comment on column tracks.search_enabled is '検索対象とするか(default: true)';
comment on column tracks.length is '曲の長さ(秒)';
comment on column tracks.bpm is 'BPM';
comment on column tracks.display_composer is '作曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column tracks.display_arranger is '編曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column tracks.display_rearranger is '再編曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column tracks.display_lyricist is '作詞者表示用(1度しか使用しない別名義などで使用する)';
comment on column tracks.display_vocalist is 'ボーカリスト表示用(1度しか使用しない別名義などで使用する)';
comment on column tracks.display_original_song is '原曲表示用(東方以外の原曲などで使用する)';
comment on column tracks.created_at is '作成日時';
comment on column tracks.updated_at is '更新日時';

create table track_distribution_service_urls (
    id         text                     not null primary key,
    track_id   text                     not null references tracks(id),
    service    distribution_service     not null,
    url        text                     not null,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp
);
comment on table  track_distribution_service_urls is '楽曲配信サービスURL';
comment on column track_distribution_service_urls.track_id is 'トラックID';
comment on column track_distribution_service_urls.service is '配信サービス';
comment on column track_distribution_service_urls.url is 'URL';
comment on column track_distribution_service_urls.created_at is '作成日時';
comment on column track_distribution_service_urls.updated_at is '更新日時';

create table track_isrcs (
    id         text                     not null primary key,
    track_id   text                     not null references tracks(id),
    isrc       text                     not null,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp
);
create unique index uk_track_isrcs_track_id_isrc on track_isrcs (track_id, isrc);
comment on table  track_isrcs is '楽曲ISRC';
comment on column track_isrcs.track_id is 'トラックID';
comment on column track_isrcs.isrc is 'ISRC(International Standard Recording Code): 国際標準レコーディングコード';
comment on column track_isrcs.created_at is '作成日時';
comment on column track_isrcs.updated_at is '更新日時';

create table tracks_arrange_circles (
    track_id   text                     not null references tracks(id),
    circle_id  text                     not null references circles(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, circle_id)
);
comment on table  tracks_arrange_circles is '楽曲編曲サークル';
comment on column tracks_arrange_circles.track_id is 'トラックID';
comment on column tracks_arrange_circles.circle_id is 'サークルID';
comment on column tracks_arrange_circles.created_at is '作成日時';
comment on column tracks_arrange_circles.updated_at is '更新日時';

create table tracks_composers (
    track_id   text                     not null references tracks(id),
    artist_id  text                     not null references artists(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, artist_id)
);
comment on table  tracks_composers is '楽曲作曲者';
comment on column tracks_composers.track_id is 'トラックID';
comment on column tracks_composers.artist_id is '作曲者ID(アーティストID)';
comment on column tracks_composers.created_at is '作成日時';
comment on column tracks_composers.updated_at is '更新日時';

create table tracks_arrangers (
    track_id   text                     not null references tracks(id),
    artist_id  text                     not null references artists(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, artist_id)
);
comment on table  tracks_arrangers is '楽曲編曲者';
comment on column tracks_arrangers.track_id is 'トラックID';
comment on column tracks_arrangers.artist_id is '編曲者ID(アーティストID)';
comment on column tracks_arrangers.created_at is '作成日時';
comment on column tracks_arrangers.updated_at is '更新日時';

create table tracks_rearrangers (
    track_id   text                     not null references tracks(id),
    artist_id  text                     not null references artists(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, artist_id)
);
comment on table  tracks_rearrangers is '楽曲再編曲者';
comment on column tracks_rearrangers.track_id is 'トラックID';
comment on column tracks_rearrangers.artist_id is '再編曲者ID(アーティストID)';
comment on column tracks_rearrangers.created_at is '作成日時';
comment on column tracks_rearrangers.updated_at is '更新日時';

create table tracks_lyricists (
    track_id   text                     not null references tracks(id),
    artist_id  text                     not null references artists(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, artist_id)
);
comment on table  tracks_lyricists is '楽曲作詞者';
comment on column tracks_lyricists.track_id is 'トラックID';
comment on column tracks_lyricists.artist_id is '作詞者ID(アーティストID)';
comment on column tracks_lyricists.created_at is '作成日時';
comment on column tracks_lyricists.updated_at is '更新日時';

create table tracks_vocalists (
    track_id   text                     not null references tracks(id),
    artist_id  text                     not null references artists(id),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, artist_id)
);
comment on table  tracks_vocalists is '楽曲ボーカリスト';
comment on column tracks_vocalists.track_id is 'トラックID';
comment on column tracks_vocalists.artist_id is 'ボーカリストID(アーティストID)';
comment on column tracks_vocalists.created_at is '作成日時';
comment on column tracks_vocalists.updated_at is '更新日時';

create table tracks_original_songs (
    track_id         text                     not null references tracks(id),
    original_song_id text                     not null references original_songs(id),
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp,
    primary key (track_id, original_song_id)
);
comment on table  tracks_original_songs is '楽曲原曲';
comment on column tracks_original_songs.track_id is 'トラックID';
comment on column tracks_original_songs.original_song_id is '原曲ID';
comment on column tracks_original_songs.created_at is '作成日時';
comment on column tracks_original_songs.updated_at is '更新日時';

create type tag_type as enum (
    'unknown',   -- 不明
    'genre',     -- ジャンル
    'ambience',  -- 雰囲気
    'instrument' -- 楽器
);

create table tags (
    id         text                     not null primary key,
    name       text                     not null,
    tag_type   tag_type                 not null default 'unknown'::tag_type,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp
);
comment on table  tags is 'タグ';
comment on column tags.name is '名前';
comment on column tags.tag_type is 'タグ種別';
comment on column tags.created_at is '作成日時';
comment on column tags.updated_at is '更新日時';

create table albums_genres (
    album_id   text                     not null references albums(id),
    tag_id     text                     not null references tags(id),
    locked     bool                     not null default false,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (album_id, tag_id)
);
comment on table  albums_genres is 'アルバムジャンル';
comment on column albums_genres.album_id is 'アルバムID';
comment on column albums_genres.tag_id is 'タグID';
comment on column albums_genres.locked is 'ロック有無(true: ロック・削除不可、false: アンロック)';
comment on column albums_genres.created_at is '作成日時';
comment on column albums_genres.updated_at is '更新日時';

create table albums_tags (
    album_id   text                     not null references albums(id),
    tag_id     text                     not null references tags(id),
    locked     bool                     not null default false,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (album_id, tag_id)
);
comment on table  albums_tags is 'アルバムタグ';
comment on column albums_tags.album_id is 'アルバムID';
comment on column albums_tags.tag_id is 'タグID';
comment on column albums_tags.locked is 'ロック有無(true: ロック、false: アンロック)';
comment on column albums_tags.created_at is '作成日時';
comment on column albums_tags.updated_at is '更新日時';

create table tracks_genres (
    track_id   text                     not null references tracks(id),
    tag_id     text                     not null references tags(id),
    locked     bool                     not null default false,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, tag_id)
);
comment on table  tracks_genres is '楽曲ジャンル';
comment on column tracks_genres.track_id is 'トラックID';
comment on column tracks_genres.tag_id is 'タグID';
comment on column tracks_genres.locked is 'ロック有無(true: ロック・削除不可、false: アンロック)';
comment on column tracks_genres.created_at is '作成日時';
comment on column tracks_genres.updated_at is '更新日時';

create table tracks_tags (
    track_id   text                     not null references tracks(id),
    tag_id     text                     not null references tags(id),
    locked     bool                     not null default false,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (track_id, tag_id)
);
comment on table  tracks_tags is '楽曲タグ';
comment on column tracks_tags.track_id is 'トラックID';
comment on column tracks_tags.tag_id is 'タグID';
comment on column tracks_tags.locked is 'ロック有無(true: ロック・削除不可、false: アンロック)';
comment on column tracks_tags.created_at is '作成日時';
comment on column tracks_tags.updated_at is '更新日時';

create table circles_tags (
    circle_id  text                     not null references circles(id),
    tag_id     text                     not null references tags(id),
    locked     bool                     not null default false,
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    primary key (circle_id, tag_id)
);
comment on table  circles_tags is 'サークルタグ';
comment on column circles_tags.circle_id is 'サークルID';
comment on column circles_tags.tag_id is 'タグID';
comment on column circles_tags.locked is 'ロック有無(true: ロック、false: アンロック)';
comment on column circles_tags.created_at is '作成日時';
comment on column circles_tags.updated_at is '更新日時';
