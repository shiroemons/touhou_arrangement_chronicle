-- migrate:up
create table users (
    id            uuid                     not null primary key default gen_random_uuid(),
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp
);
comment on table users is 'サイトのユーザー基本情報を管理するテーブル（最小限の情報のみ）';
comment on column users.id is 'ユーザーID';
comment on column users.created_at is '作成日時';
comment on column users.updated_at is '更新日時';

create table user_authentications (
    id                 uuid                     not null primary key default gen_random_uuid(),
    created_at         timestamp with time zone not null default current_timestamp,
    updated_at         timestamp with time zone not null default current_timestamp,
    user_id            uuid                     not null unique references users(id) on delete cascade, -- アプリケーションのユーザーID
    auth0_user_id      text                     not null unique, -- Auth0から払い出されるユニークなユーザーID (例: auth0|abcdef123456)
    last_login_at      timestamp with time zone
);
create index idx_user_authentications_user_id on user_authentications (user_id);
create index idx_user_authentications_auth0_user_id on user_authentications (auth0_user_id);
comment on table user_authentications is 'ユーザーの外部認証（Auth0など）情報を管理するテーブル';
comment on column user_authentications.id is '認証情報ID';
comment on column user_authentications.created_at is '作成日時';
comment on column user_authentications.updated_at is '更新日時';
comment on column user_authentications.user_id is '関連するアプリケーションユーザーID';
comment on column user_authentications.auth0_user_id is 'Auth0から払い出されるユーザーID';
comment on column user_authentications.last_login_at is 'アプリケーションでの最終ログイン日時（Auth0のデータと同期するか検討）';

create table user_profiles (
    id            uuid                     not null primary key default gen_random_uuid(),
    created_at    timestamp with time zone not null default current_timestamp,
    updated_at    timestamp with time zone not null default current_timestamp,
    user_id       uuid                     not null unique references users(id) on delete cascade,
    username      text                     not null unique,
    display_name  text                     not null,
    bio           text,
    avatar_url    text
);
create index idx_user_profiles_user_id on user_profiles (user_id); -- 外部キーには通常インデックスが推奨される
comment on table user_profiles is 'ユーザーのプロフィール情報を管理するテーブル';
comment on column user_profiles.id is 'プロフィール情報ID';
comment on column user_profiles.created_at is '作成日時';
comment on column user_profiles.updated_at is '更新日時';
comment on column user_profiles.user_id is '関連するユーザーID';
comment on column user_profiles.display_name is '表示名';
comment on column user_profiles.bio is '自己紹介';
comment on column user_profiles.avatar_url is 'アバター画像のURL';

create table user_settings (
    id                       uuid                     not null primary key default gen_random_uuid(),
    created_at               timestamp with time zone not null default current_timestamp,
    updated_at               timestamp with time zone not null default current_timestamp,
    user_id                  uuid                     not null unique references users(id) on delete cascade,
    is_public_profile        boolean                  not null default false
);
create index idx_user_settings_user_id on user_settings (user_id);
comment on table user_settings is 'ユーザーのアプリケーション設定を管理するテーブル';
comment on column user_settings.id is '設定情報ID';
comment on column user_settings.created_at is '作成日時';
comment on column user_settings.updated_at is '更新日時';
comment on column user_settings.user_id is '関連するユーザーID';
comment on column user_settings.is_public_profile is 'プロフィールを公開するかどうか';

-- migrate:down

-- テーブルの削除は依存関係のある順序で実行
drop table if exists user_settings cascade;
drop table if exists user_profiles cascade;
drop table if exists user_authentications cascade;
drop table if exists users cascade;
