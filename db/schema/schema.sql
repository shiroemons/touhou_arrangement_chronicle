create table admin_users (
    id                     text                     not null primary key default cuid(),
    created_at             timestamp with time zone not null default current_timestamp,
    updated_at             timestamp with time zone not null default current_timestamp,
    name                   text,
    email                  text                     not null default '',
    encrypted_password     text                     not null default '',
    reset_password_token   text,
    reset_password_sent_at timestamp with time zone,
    remember_created_at    timestamp with time zone,
    sign_in_count          integer                  not null default 0,
    current_sign_in_at     timestamp with time zone,
    last_sign_in_at        timestamp with time zone,
    current_sign_in_ip     text,
    last_sign_in_ip        text,
    confirmation_token     text,
    confirmed_at           timestamp with time zone,
    confirmation_sent_at   timestamp with time zone,
    unconfirmed_email      text
);
create unique index index_admin_users_on_email on admin_users(email);
create unique index index_admin_users_on_reset_password_token on admin_users(reset_password_token);
create unique index index_admin_users_on_confirmation_token on admin_users(confirmation_token);
comment on table admin_users is '管理者ユーザー';
comment on column admin_users.id is '管理者ユーザーID';
comment on column admin_users.created_at is '作成日時';
comment on column admin_users.updated_at is '更新日時';
comment on column admin_users.name is '名前';
comment on column admin_users.email is 'メールアドレス';
comment on column admin_users.encrypted_password is 'パスワード';
comment on column admin_users.reset_password_token is 'パスワードリセットトークン';
comment on column admin_users.reset_password_sent_at is 'パスワードリセット送信日時';
comment on column admin_users.remember_created_at is 'ログイン情報記憶日時';
comment on column admin_users.sign_in_count is 'ログイン回数';
comment on column admin_users.current_sign_in_at is '現在のログイン日時';
comment on column admin_users.last_sign_in_at is '最後のログイン日時';
comment on column admin_users.current_sign_in_ip is '現在のログインIPアドレス';
comment on column admin_users.last_sign_in_ip is '最後のログインIPアドレス';
comment on column admin_users.confirmation_token is '確認トークン';
comment on column admin_users.confirmed_at is '確認日時';
comment on column admin_users.confirmation_sent_at is '確認送信日時';
comment on column admin_users.unconfirmed_email is '未確認メールアドレス';

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
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp,
    name          text                     not null,
    name_reading  text,
    short_name    text                     not null,
    product_type  product_type             not null,
    series_number numeric(5,2)             not null
);
comment on table  products is '原作';
comment on column products.id is '原作ID';
comment on column products.created_at is '作成日時';
comment on column products.updated_at is '更新日時';
comment on column products.name is '名前';
comment on column products.name_reading is '名前読み方';
comment on column products.short_name is '短い名前';
comment on column products.product_type is '原作種別';
comment on column products.series_number is 'シリーズ番号';

create table original_songs (
    id           text                     not null primary key,
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    product_id   text                     not null references products(id),
    name         text                     not null,
    name_reading text,
    composer     text,
    arranger     text,
    track_number integer                  not null,
    is_original  boolean                  not null default false,
    source_id    text
);
comment on table  original_songs is '原曲';
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
comment on column original_songs.is_original is 'オリジナル有無(true: オリジナル(初出)、false: 再録など)';
comment on column original_songs.source_id is '原曲元の原曲ID';

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
    id           text                     not null primary key default cuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    product_id   text                     not null references products(id),
    service      distribution_service     not null,
    url          text                     not null
);
create unique index uk_pdsu_product_id_service on product_distribution_service_urls (product_id, service);
comment on table  product_distribution_service_urls is '原作(音楽)配信サービスURL';
comment on column product_distribution_service_urls.id is '原作(音楽)配信サービスURLのID';
comment on column product_distribution_service_urls.created_at is '作成日時';
comment on column product_distribution_service_urls.updated_at is '更新日時';
comment on column product_distribution_service_urls.product_id is '原作ID';
comment on column product_distribution_service_urls.service is '配信サービス';
comment on column product_distribution_service_urls.url is 'URL';

create table original_song_distribution_service_urls (
    id               text                     not null primary key default cuid(),
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp,
    original_song_id text                     not null references original_songs(id),
    service          distribution_service     not null,
    url              text                     not null
);
create unique index uk_osdsu_original_song_id_service on original_song_distribution_service_urls (original_song_id, service);
comment on table  original_song_distribution_service_urls is '原曲配信サービスURL';
comment on column original_song_distribution_service_urls.id is '原曲配信サービスURLのID';
comment on column original_song_distribution_service_urls.created_at is '作成日時';
comment on column original_song_distribution_service_urls.updated_at is '更新日時';
comment on column original_song_distribution_service_urls.original_song_id is '原曲ID';
comment on column original_song_distribution_service_urls.service is '配信サービス';
comment on column original_song_distribution_service_urls.url is 'URL';

create table event_series (
    id           text                     not null primary key default cuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    name         text                     not null unique,
    display_name text                     not null,
    slug         text                     not null unique default gen_random_uuid(),
    published_at timestamp with time zone,
    archived_at  timestamp with time zone
);
comment on table  event_series is 'イベントシリーズ';
comment on column event_series.id is 'イベントシリーズID';
comment on column event_series.created_at is '作成日時';
comment on column event_series.updated_at is '更新日時';
comment on column event_series.name is '名前';
comment on column event_series.display_name is '表示名';
comment on column event_series.slug is 'スラッグ';
comment on column event_series.published_at is '公開日時';
comment on column event_series.archived_at is 'アーカイブ日時';

create type event_status as enum (
    'scheduled',    -- 開催予定
    'completed',    -- 開催済み
    'cancelled',    -- 中止
    'postpone',     -- 延期(開催日未定)
    'rescheduled',  -- 延期(開催日決定)
    'moved_online', -- オンライン開催に変更
    'other'         -- その他
);

create type event_format as enum (
    'offline', -- オフライン開催
    'online',  -- オンライン開催
    'hybrid'   -- オフライン・オンライン両方開催
);

create table events (
    id              text                     not null primary key default cuid(),
    created_at      timestamp with time zone not null default current_timestamp,
    updated_at      timestamp with time zone not null default current_timestamp,
    event_series_id text                     not null references event_series(id),
    name            text                     not null unique,
    name_reading    text,
    display_name    text                     not null,
    slug            text                     not null unique default gen_random_uuid(),
    start_date      date,
    end_date        date,
    event_status    event_status             not null default 'scheduled'::event_status,
    format          event_format             not null default 'offline'::event_format,
    region_code     text                     not null default 'JP',
    address         text,
    description     text,
    url             text,
    twitter_url     text,
    published_at    timestamp with time zone,
    archived_at     timestamp with time zone
);
comment on table  events is 'イベント';
comment on column events.id is 'イベントID';
comment on column events.created_at is '作成日時';
comment on column events.updated_at is '更新日時';
comment on column events.event_series_id is 'イベントシリーズID';
comment on column events.name is '名前';
comment on column events.name_reading is '名前読み方';
comment on column events.display_name is '表示名';
comment on column events.slug is 'スラッグ';
comment on column events.start_date is '開始日';
comment on column events.end_date is '終了日';
comment on column events.event_status is 'ステータス/scheduled: 開催済み, cancelled: 中止, postpone: 延期(開催日未定), rescheduled: 延期(開催日決定), moved_online: オンライン開催に変更, other: その他/default: scheduled';
comment on column events.format is '形式/offline: オフライン開催, online: オフライン開催, mixed: 両方開催/default: offline';
comment on column events.region_code is 'リージョンコード/default: JP';
comment on column events.address is '開催場所';
comment on column events.description is '説明';
comment on column events.url is 'URL';
comment on column events.twitter_url is 'Twitter URL';
comment on column events.published_at is '公開日時';
comment on column events.archived_at is 'アーカイブ日時';

create table sub_events (
    id           text                     not null primary key default cuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    event_id     text                     not null references events(id),
    name         text                     not null unique,
    name_reading text,
    display_name text                     not null,
    slug         text                     not null unique default gen_random_uuid(),
    event_date   date,
    event_status event_status             not null default 'scheduled'::event_status,
    description  text,
    published_at timestamp with time zone,
    archived_at  timestamp with time zone
);
comment on table  sub_events is 'サブイベント';
comment on column sub_events.id is 'サブイベントID';
comment on column sub_events.created_at is '作成日時';
comment on column sub_events.updated_at is '更新日時';
comment on column sub_events.event_id is 'イベントID';
comment on column sub_events.name is '名前(例: 〇〇 2日目)';
comment on column sub_events.name_reading is '名前読み方';
comment on column sub_events.display_name is '表示名';
comment on column sub_events.slug is 'スラッグ';
comment on column sub_events.event_date is '開催日';
comment on column sub_events.event_status is 'ステータス/scheduled: 開催済み, cancelled: 中止, postpone: 延期(開催日未定), rescheduled: 延期(開催日決定), moved_online: オンライン開催に変更, other: その他/default: scheduled';
comment on column sub_events.description is '説明';
comment on column sub_events.published_at is '公開日時';
comment on column sub_events.archived_at is 'アーカイブ日時';

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
    id                    text                     not null primary key default cuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text                     not null,
    name_reading          text,
    slug                  text                     not null unique default gen_random_uuid(),
    initial_letter_type   initial_letter_type      not null,
    initial_letter_detail text,
    description           text,
    url                   text,
    blog_url              text,
    twitter_url           text,
    youtube_channel_url   text,
    published_at          timestamp with time zone,
    archived_at           timestamp with time zone
);
comment on table  artists is 'アーティスト';
comment on column artists.id is 'アーティストID';
comment on column artists.created_at is '作成日時';
comment on column artists.updated_at is '更新日時';
comment on column artists.name is '名前';
comment on column artists.name_reading is '名前読み方';
comment on column artists.slug is 'スラッグ';
comment on column artists.initial_letter_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column artists.initial_letter_detail is '頭文字の文字種別詳細';
comment on column artists.description is '説明';
comment on column artists.url is 'URL';
comment on column artists.blog_url is 'ブログ URL';
comment on column artists.twitter_url is 'Twitter URL';
comment on column artists.youtube_channel_url is 'YouTubeチャンネル URL';
comment on column artists.published_at is '公開日時';
comment on column artists.archived_at is 'アーカイブ日時';

create table circles (
    id                    text                     not null primary key default cuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text                     not null,
    name_reading          text,
    slug                  text                     not null unique default gen_random_uuid(),
    initial_letter_type   initial_letter_type      not null,
    initial_letter_detail text,
    description           text,
    url                   text,
    blog_url              text,
    twitter_url           text,
    youtube_channel_url   text,
    published_at          timestamp with time zone,
    archived_at           timestamp with time zone
);
comment on table  circles is 'サークル';
comment on column circles.id is 'サークルID';
comment on column circles.created_at is '作成日時';
comment on column circles.updated_at is '更新日時';
comment on column circles.name is '名前';
comment on column circles.name_reading is '名前読み方';
comment on column circles.slug is 'スラッグ';
comment on column circles.initial_letter_type is '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';
comment on column circles.initial_letter_detail is '頭文字の文字種別詳細';
comment on column circles.description is '説明';
comment on column circles.url is 'URL';
comment on column circles.blog_url is 'ブログ URL';
comment on column circles.twitter_url is 'Twitter URL';
comment on column circles.youtube_channel_url is 'YouTubeチャンネル URL';
comment on column circles.published_at is '公開日時';
comment on column circles.archived_at is 'アーカイブ日時';

create table albums (
    id                    text                     not null primary key default cuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    name                  text                     not null,
    name_reading          text,
    slug                  text                     not null unique default gen_random_uuid(),
    release_circle_name   text,
    release_date          date,
    event_id              text,
    sub_event_id          text,
    album_number          text,
    event_price           numeric,
    currency              text                     not null default 'JPY',
    credit                text,
    introduction          text,
    url                   text,
    published_at          timestamp with time zone,
    archived_at           timestamp with time zone
);
comment on table  albums is 'アルバム';
comment on column albums.id is 'アルバムID';
comment on column albums.created_at is '作成日時';
comment on column albums.updated_at is '更新日時';
comment on column albums.name is '名前';
comment on column albums.name_reading is '名前読み方';
comment on column albums.slug is 'スラッグ';
comment on column albums.release_circle_name is '頒布サークル名';
comment on column albums.release_date is '頒布日';
comment on column albums.event_id is 'イベントID';
comment on column albums.sub_event_id is 'サブイベントID';
comment on column albums.event_price is 'イベント価格';
comment on column albums.currency is '通貨(default: JPY)';
comment on column albums.credit is 'クレジット';
comment on column albums.introduction is '紹介';
comment on column albums.url is 'URL';
comment on column albums.published_at is '公開日時';
comment on column albums.archived_at is 'アーカイブ日時';

create table albums_circles (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   text                     not null references albums(id),
    circle_id  text                     not null references circles(id),
    primary key (album_id, circle_id)
);
comment on table  albums_circles is 'アルバムとサークルの中間テーブル';
comment on column albums_circles.created_at is '作成日時';
comment on column albums_circles.updated_at is '更新日時';
comment on column albums_circles.album_id is 'アルバムID';
comment on column albums_circles.circle_id is 'サークルID';

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
    id           text                     not null primary key default cuid(),
    created_at   timestamp with time zone not null default current_timestamp,
    updated_at   timestamp with time zone not null default current_timestamp,
    album_id     text                     not null references albums(id),
    shop         shop                     not null,
    url          text                     not null,
    tax_included bool                     not null default false,
    shop_price   numeric                  not null,
    currency     text                     not null default 'JPY'
);
comment on table  album_consignment_shops is 'アルバム委託販売ショップ';
comment on column album_consignment_shops.id is 'アルバム委託販売ショップID';
comment on column album_consignment_shops.created_at is '作成日時';
comment on column album_consignment_shops.updated_at is '更新日時';
comment on column album_consignment_shops.album_id is 'アルバムID';
comment on column album_consignment_shops.shop is 'ショップ';
comment on column album_consignment_shops.url is 'URL';
comment on column album_consignment_shops.tax_included is '税込みか否か(true: 税込み、false: 税抜き・税別)';
comment on column album_consignment_shops.shop_price is 'ショップ価格';
comment on column album_consignment_shops.currency is '通貨(default: JPY)';

create table album_distribution_service_urls (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   text                     not null references albums(id),
    service    distribution_service     not null,
    url        text                     not null
);
create unique index uk_adsu_album_id_service on album_distribution_service_urls (album_id, service);
comment on table  album_distribution_service_urls is 'アルバム配信サービスURL';
comment on column album_distribution_service_urls.id is 'アルバム配信サービスURLのID';
comment on column album_distribution_service_urls.created_at is '作成日時';
comment on column album_distribution_service_urls.updated_at is '更新日時';
comment on column album_distribution_service_urls.album_id is 'アルバムID';
comment on column album_distribution_service_urls.service is '配信サービス';
comment on column album_distribution_service_urls.url is 'URL';

create table album_upcs (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   text                     not null references albums(id),
    upc        text                     not null
);
create unique index uk_album_upcs_album_id_upc on album_upcs (album_id, upc);
comment on table  album_upcs is 'アルバムUPC';
comment on column album_upcs.id is 'アルバムUPCのID';
comment on column album_upcs.created_at is '作成日時';
comment on column album_upcs.updated_at is '更新日時';
comment on column album_upcs.album_id is 'アルバムID';
comment on column album_upcs.upc is 'UPC(JAN)コード';

create table songs (
    id                    text                     not null primary key default cuid(),
    created_at            timestamp with time zone not null default current_timestamp,
    updated_at            timestamp with time zone not null default current_timestamp,
    circle_id             text,
    album_id              text,
    name                  text                     not null,
    name_reading          text,
    slug                  text                     not null unique default gen_random_uuid(),
    disc_number           integer                  not null default 1,
    track_number          integer                  not null,
    release_date          date,
    length                integer,
    bpm                   integer,
    description           text,
    display_composer      text,
    display_arranger      text,
    display_rearranger    text,
    display_lyricist      text,
    display_vocalist      text,
    display_original_song text,
    published_at          timestamp with time zone,
    archived_at           timestamp with time zone
);
comment on table  songs is '楽曲';
comment on column songs.id is '楽曲ID';
comment on column songs.created_at is '作成日時';
comment on column songs.updated_at is '更新日時';
comment on column songs.circle_id is 'サークルID';
comment on column songs.album_id is 'アルバムID';
comment on column songs.name is '名前';
comment on column songs.name_reading is '名前読み方';
comment on column songs.slug is 'スラッグ';
comment on column songs.disc_number is 'ディスク番号(default: 1)';
comment on column songs.track_number is 'トラック番号';
comment on column songs.release_date is '頒布日(アルバムの頒布日と異なる場合に使用する)';
comment on column songs.length is '曲の長さ(秒)';
comment on column songs.bpm is 'BPM';
comment on column songs.description is '説明';
comment on column songs.display_composer is '作曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column songs.display_arranger is '編曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column songs.display_rearranger is '再編曲者表示用(1度しか使用しない別名義などで使用する)';
comment on column songs.display_lyricist is '作詞者表示用(1度しか使用しない別名義などで使用する)';
comment on column songs.display_vocalist is 'ボーカリスト表示用(1度しか使用しない別名義などで使用する)';
comment on column songs.display_original_song is '原曲表示用(東方以外の原曲などで使用する)';
comment on column songs.published_at is '公開日時';
comment on column songs.archived_at is 'アーカイブ日時';

create table lyrics (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    content    text                     not null,
    language   text                              default 'ja' -- 言語を指定。デフォルトは日本語
);
comment on table  lyrics is '歌詞';
comment on column lyrics.id is '歌詞ID';
comment on column lyrics.created_at is '作成日時';
comment on column lyrics.updated_at is '更新日時';
comment on column lyrics.song_id is '楽曲ID';
comment on column lyrics.content is '歌詞';
comment on column lyrics.language is '言語(default: ja)';

create table song_distribution_service_urls (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    service    distribution_service     not null,
    url        text                     not null
);
create unique index uk_sdsu_song_id_service on song_distribution_service_urls (song_id, service);
comment on table  song_distribution_service_urls is '楽曲配信サービスURL';
comment on column song_distribution_service_urls.id is '楽曲配信サービスURLのID';
comment on column song_distribution_service_urls.created_at is '作成日時';
comment on column song_distribution_service_urls.updated_at is '更新日時';
comment on column song_distribution_service_urls.song_id is '楽曲ID';
comment on column song_distribution_service_urls.service is '配信サービス';
comment on column song_distribution_service_urls.url is 'URL';

create table song_isrcs (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    isrc       text                     not null
);
create unique index uk_song_isrcs_song_id_isrc on song_isrcs (song_id, isrc);
comment on table  song_isrcs is '楽曲ISRC';
comment on column song_isrcs.id is '楽曲ISRCのID';
comment on column song_isrcs.created_at is '作成日時';
comment on column song_isrcs.updated_at is '更新日時';
comment on column song_isrcs.song_id is '楽曲ID';
comment on column song_isrcs.isrc is 'ISRC(International Standard Recording Code): 国際標準レコーディングコード';

create table songs_arrange_circles (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    circle_id  text                     not null references circles(id),
    primary key (song_id, circle_id)
);
comment on table  songs_arrange_circles is '楽曲編曲サークル';
comment on column songs_arrange_circles.created_at is '作成日時';
comment on column songs_arrange_circles.updated_at is '更新日時';
comment on column songs_arrange_circles.song_id is '楽曲ID';
comment on column songs_arrange_circles.circle_id is 'サークルID';

create table songs_composers (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    artist_id  text                     not null references artists(id),
    primary key (song_id, artist_id)
);
comment on table  songs_composers is '楽曲作曲者';
comment on column songs_composers.created_at is '作成日時';
comment on column songs_composers.updated_at is '更新日時';
comment on column songs_composers.song_id is '楽曲ID';
comment on column songs_composers.artist_id is '作曲者ID(アーティストID)';

create table songs_arrangers (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    artist_id  text                     not null references artists(id),
    primary key (song_id, artist_id)
);
comment on table  songs_arrangers is '楽曲編曲者';
comment on column songs_arrangers.created_at is '作成日時';
comment on column songs_arrangers.updated_at is '更新日時';
comment on column songs_arrangers.song_id is '楽曲ID';
comment on column songs_arrangers.artist_id is '編曲者ID(アーティストID)';

create table songs_rearrangers (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    artist_id  text                     not null references artists(id),
    primary key (song_id, artist_id)
);
comment on table  songs_rearrangers is '楽曲再編曲者';
comment on column songs_rearrangers.created_at is '作成日時';
comment on column songs_rearrangers.updated_at is '更新日時';
comment on column songs_rearrangers.song_id is '楽曲ID';
comment on column songs_rearrangers.artist_id is '再編曲者ID(アーティストID)';

create table songs_lyricists (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    artist_id  text                     not null references artists(id),
    primary key (song_id, artist_id)
);
comment on table  songs_lyricists is '楽曲作詞者';
comment on column songs_lyricists.created_at is '作成日時';
comment on column songs_lyricists.updated_at is '更新日時';
comment on column songs_lyricists.song_id is '楽曲ID';
comment on column songs_lyricists.artist_id is '作詞者ID(アーティストID)';

create table songs_vocalists (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    artist_id  text                     not null references artists(id),
    primary key (song_id, artist_id)
);
comment on table  songs_vocalists is '楽曲ボーカリスト';
comment on column songs_vocalists.created_at is '作成日時';
comment on column songs_vocalists.updated_at is '更新日時';
comment on column songs_vocalists.song_id is '楽曲ID';
comment on column songs_vocalists.artist_id is 'ボーカリストID(アーティストID)';

create table songs_original_songs (
    created_at       timestamp with time zone not null default current_timestamp,
    updated_at       timestamp with time zone not null default current_timestamp,
    song_id          text                     not null references songs(id),
    original_song_id text                     not null references original_songs(id),
    primary key (song_id, original_song_id)
);
comment on table  songs_original_songs is '楽曲原曲';
comment on column songs_original_songs.created_at is '作成日時';
comment on column songs_original_songs.updated_at is '更新日時';
comment on column songs_original_songs.song_id is '楽曲ID';
comment on column songs_original_songs.original_song_id is '原曲ID';

create table songs_circles (
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    circle_id  text                     not null references circles(id),
    primary key (song_id, circle_id)
);
comment on table  songs_circles is '楽曲とサークルの中間テーブル';
comment on column songs_circles.created_at is '作成日時';
comment on column songs_circles.updated_at is '更新日時';
comment on column songs_circles.song_id is '楽曲ID';
comment on column songs_circles.circle_id is 'サークルID';

create table genres (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    name       text                     not null unique
);
comment on table  genres is 'ジャンル';
comment on column genres.id is 'ジャンルID';
comment on column genres.created_at is '作成日時';
comment on column genres.updated_at is '更新日時';
comment on column genres.name is '名前';

create type tag_type as enum (
    'unknown',   -- 不明
    'genre',     -- ジャンル
    'ambience',  -- 雰囲気
    'instrument' -- 楽器
);

create table tags (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    name       text                     not null unique,
    tag_type   tag_type                 not null default 'unknown'::tag_type
);
comment on table  tags is 'タグ';
comment on column tags.id is 'タグID';
comment on column tags.created_at is '作成日時';
comment on column tags.updated_at is '更新日時';
comment on column tags.name is '名前';
comment on column tags.tag_type is 'タグ種別';

create table albums_genres (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   text                     not null references albums(id),
    genre_id   text                     not null references genres(id),
    locked_at  timestamp with time zone
);
create unique index uk_albums_genres_album_id_genre_id on albums_genres (album_id, genre_id);
comment on table  albums_genres is 'アルバムジャンル';
comment on column albums_genres.id is 'アルバムジャンルID';
comment on column albums_genres.created_at is '作成日時';
comment on column albums_genres.updated_at is '更新日時';
comment on column albums_genres.album_id is 'アルバムID';
comment on column albums_genres.genre_id is 'ジャンルID';
comment on column albums_genres.locked_at is 'ロック日時';

create table albums_tags (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    album_id   text                     not null references albums(id),
    tag_id     text                     not null references tags(id),
    locked_at  timestamp with time zone
);
create unique index uk_albums_tags_song_id_tag_id on albums_tags (album_id, tag_id);
comment on table  albums_tags is 'アルバムタグ';
comment on column albums_tags.id is 'アルバムタグID';
comment on column albums_tags.created_at is '作成日時';
comment on column albums_tags.updated_at is '更新日時';
comment on column albums_tags.album_id is 'アルバムID';
comment on column albums_tags.tag_id is 'タグID';
comment on column albums_tags.locked_at is 'ロック日時';

create table songs_genres (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    genre_id   text                     not null references genres(id),
    locked_at  timestamp with time zone
);
create unique index uk_songs_genres_song_id_genre_id on songs_genres (song_id, genre_id);
comment on table  songs_genres is '楽曲ジャンル';
comment on column songs_genres.id is '楽曲ジャンルID';
comment on column songs_genres.created_at is '作成日時';
comment on column songs_genres.updated_at is '更新日時';
comment on column songs_genres.song_id is '楽曲ID';
comment on column songs_genres.genre_id is 'ジャンルID';
comment on column songs_genres.locked_at is 'ロック日時';

create table songs_tags (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    song_id    text                     not null references songs(id),
    tag_id     text                     not null references tags(id),
    locked_at  timestamp with time zone
);
create unique index uk_songs_tags_song_id_tag_id on songs_tags (song_id, tag_id);
comment on table  songs_tags is '楽曲タグ';
comment on column songs_tags.id is '楽曲タグID';
comment on column songs_tags.created_at is '作成日時';
comment on column songs_tags.updated_at is '更新日時';
comment on column songs_tags.song_id is '楽曲ID';
comment on column songs_tags.tag_id is 'タグID';
comment on column songs_tags.locked_at is 'ロック日時';

create table circles_genres (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    circle_id  text                     not null references circles(id),
    genre_id   text                     not null references genres(id),
    locked_at  timestamp with time zone
);
create unique index uk_circles_genres_circle_id_genre_id on circles_genres (circle_id, genre_id);
comment on table  circles_genres is 'サークルジャンル';
comment on column circles_genres.id is 'サークルジャンルID';
comment on column circles_genres.created_at is '作成日時';
comment on column circles_genres.updated_at is '更新日時';
comment on column circles_genres.circle_id is 'サークルID';
comment on column circles_genres.genre_id is 'ジャンルID';
comment on column circles_genres.locked_at is 'ロック日時';

create table circles_tags (
    id         text                     not null primary key default cuid(),
    created_at timestamp with time zone not null default current_timestamp,
    updated_at timestamp with time zone not null default current_timestamp,
    circle_id  text                     not null references circles(id),
    tag_id     text                     not null references tags(id),
    locked_at  timestamp with time zone
);
create unique index uk_circles_tags_circle_id_tag_id on circles_tags (circle_id, tag_id);
comment on table  circles_tags is 'サークルタグ';
comment on column circles_tags.id is 'サークルタグID';
comment on column circles_tags.created_at is '作成日時';
comment on column circles_tags.updated_at is '更新日時';
comment on column circles_tags.circle_id is 'サークルID';
comment on column circles_tags.tag_id is 'タグID';
comment on column circles_tags.locked_at is 'ロック日時';
