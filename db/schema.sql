SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: first_character_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.first_character_type AS ENUM (
    'symbol',
    'number',
    'alphabet',
    'hiragana',
    'katakana',
    'kanji',
    'other'
);


--
-- Name: product_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_type AS ENUM (
    'pc98',
    'windows',
    'zuns_music_collection',
    'akyus_untouched_score',
    'commercial_books',
    'tasofro',
    'other'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album_discs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.album_discs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    album_id uuid NOT NULL,
    disc_number integer,
    name text,
    description text,
    note text,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE album_discs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.album_discs IS 'アルバムが複数ディスクで構成される場合に各ディスクの情報（番号、名称、説明）を管理するテーブル';


--
-- Name: COLUMN album_discs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.id IS 'アルバムディスクID';


--
-- Name: COLUMN album_discs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.created_at IS '作成日時';


--
-- Name: COLUMN album_discs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.updated_at IS '更新日時';


--
-- Name: COLUMN album_discs.album_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.album_id IS 'アルバムID';


--
-- Name: COLUMN album_discs.disc_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.disc_number IS 'ディスクの通し番号（1枚目=1、2枚目=2など）';


--
-- Name: COLUMN album_discs.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.name IS 'ディスク名（必要な場合）';


--
-- Name: COLUMN album_discs.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.description IS 'ディスクに関する説明（例: ボーナスディスクの詳細など）';


--
-- Name: COLUMN album_discs.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs.note IS '備考';


--
-- Name: COLUMN album_discs."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_discs."position" IS '順序';


--
-- Name: album_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.album_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    album_id uuid NOT NULL,
    price_type text NOT NULL,
    is_free boolean DEFAULT false NOT NULL,
    price numeric NOT NULL,
    currency text DEFAULT 'JPY'::text NOT NULL,
    tax_included boolean DEFAULT false NOT NULL,
    shop_id uuid,
    url text,
    description text,
    note text,
    "position" integer DEFAULT 1 NOT NULL,
    CONSTRAINT album_prices_check CHECK ((((is_free = true) AND (price = (0)::numeric)) OR ((is_free = false) AND (price > (0)::numeric)))),
    CONSTRAINT album_prices_price_type_check CHECK ((price_type = ANY (ARRAY['event'::text, 'shop'::text])))
);


--
-- Name: TABLE album_prices; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.album_prices IS 'アルバム価格情報を管理（イベント価格、ショップ価格、無料頒布など）';


--
-- Name: COLUMN album_prices.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.id IS 'アルバム価格のID';


--
-- Name: COLUMN album_prices.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.created_at IS '作成日時';


--
-- Name: COLUMN album_prices.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.updated_at IS '更新日時';


--
-- Name: COLUMN album_prices.album_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.album_id IS 'アルバムID';


--
-- Name: COLUMN album_prices.price_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.price_type IS '価格の種類(event: イベント価格, shop: 通常価格)';


--
-- Name: COLUMN album_prices.is_free; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.is_free IS '無料頒布有無(true: 無料頒布, false: 有料頒布)';


--
-- Name: COLUMN album_prices.price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.price IS '価格';


--
-- Name: COLUMN album_prices.currency; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.currency IS '通貨(default: JPY)';


--
-- Name: COLUMN album_prices.tax_included; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.tax_included IS '税込みか否か(true: 税込み、false: 税抜き・税別)';


--
-- Name: COLUMN album_prices.shop_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.shop_id IS 'ショップID（NULL可、ある場合はshopsテーブルを参照）';


--
-- Name: COLUMN album_prices.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.url IS 'URL';


--
-- Name: COLUMN album_prices.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.description IS '説明';


--
-- Name: COLUMN album_prices.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices.note IS '備考';


--
-- Name: COLUMN album_prices."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_prices."position" IS '順序';


--
-- Name: album_upcs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.album_upcs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    album_id uuid NOT NULL,
    upc text NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE album_upcs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.album_upcs IS 'アルバムに付与されるUPC(JAN)コードを管理するテーブル（商品バーコード情報）';


--
-- Name: COLUMN album_upcs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs.id IS 'アルバムUPCのID';


--
-- Name: COLUMN album_upcs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs.created_at IS '作成日時';


--
-- Name: COLUMN album_upcs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs.updated_at IS '更新日時';


--
-- Name: COLUMN album_upcs.album_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs.album_id IS 'アルバムID';


--
-- Name: COLUMN album_upcs.upc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs.upc IS 'アルバムに割り当てられたUPC(JAN)コード(バーコード)';


--
-- Name: COLUMN album_upcs."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.album_upcs."position" IS '複数UPCがある場合の並び順';


--
-- Name: albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    name_reading text,
    slug text DEFAULT gen_random_uuid() NOT NULL,
    release_circle_id uuid,
    release_circle_name text,
    release_date date,
    release_year integer,
    release_month integer,
    event_day_id uuid,
    album_number text,
    credit text,
    introduction text,
    description text,
    note text,
    url text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE albums; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.albums IS '東方アレンジアルバム情報を管理';


--
-- Name: COLUMN albums.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.id IS 'アルバムID';


--
-- Name: COLUMN albums.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.created_at IS '作成日時';


--
-- Name: COLUMN albums.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.updated_at IS '更新日時';


--
-- Name: COLUMN albums.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.name IS '名前';


--
-- Name: COLUMN albums.name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.name_reading IS '名前読み方';


--
-- Name: COLUMN albums.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.slug IS 'スラッグ';


--
-- Name: COLUMN albums.release_circle_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.release_circle_id IS '頒布サークルID';


--
-- Name: COLUMN albums.release_circle_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.release_circle_name IS '頒布サークル名';


--
-- Name: COLUMN albums.release_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.release_date IS '頒布日';


--
-- Name: COLUMN albums.release_year; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.release_year IS '頒布年';


--
-- Name: COLUMN albums.release_month; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.release_month IS '頒布月';


--
-- Name: COLUMN albums.event_day_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.event_day_id IS 'イベント日程ID';


--
-- Name: COLUMN albums.credit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.credit IS 'クレジット';


--
-- Name: COLUMN albums.introduction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.introduction IS '紹介';


--
-- Name: COLUMN albums.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.description IS '説明';


--
-- Name: COLUMN albums.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.note IS '備考';


--
-- Name: COLUMN albums.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.url IS 'URL';


--
-- Name: COLUMN albums.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.published_at IS '公開日時';


--
-- Name: COLUMN albums.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums.archived_at IS 'アーカイブ日時';


--
-- Name: COLUMN albums."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums."position" IS '順序';


--
-- Name: albums_circles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums_circles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    album_id uuid NOT NULL,
    circle_id uuid NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE albums_circles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.albums_circles IS 'アルバムとサークルを関連付ける中間テーブル（1枚のアルバムに複数サークルが関与するケースをサポート）';


--
-- Name: COLUMN albums_circles.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles.id IS 'アルバムとサークルの中間テーブルのID';


--
-- Name: COLUMN albums_circles.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles.created_at IS '作成日時';


--
-- Name: COLUMN albums_circles.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles.updated_at IS '更新日時';


--
-- Name: COLUMN albums_circles.album_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles.album_id IS '関与するアルバムのID';


--
-- Name: COLUMN albums_circles.circle_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles.circle_id IS '関与するサークルのID';


--
-- Name: COLUMN albums_circles."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.albums_circles."position" IS '複数サークルが関わる場合の表示順序';


--
-- Name: artist_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist_names (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    artist_id uuid NOT NULL,
    name text NOT NULL,
    name_reading text,
    is_main_name boolean DEFAULT false NOT NULL,
    first_character_type public.first_character_type NOT NULL,
    first_character text,
    first_character_row text,
    description text,
    note text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    CONSTRAINT artist_names_check CHECK ((((first_character_type = ANY (ARRAY['alphabet'::public.first_character_type, 'hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::public.first_character_type, 'hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character IS NULL)))),
    CONSTRAINT artist_names_check1 CHECK ((((first_character_type = ANY (ARRAY['hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character_row IS NULL))))
);


--
-- Name: TABLE artist_names; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.artist_names IS 'アーティストの本名義・別名義を一元管理するテーブル';


--
-- Name: COLUMN artist_names.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.id IS 'アーティスト名ID';


--
-- Name: COLUMN artist_names.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.created_at IS '作成日時';


--
-- Name: COLUMN artist_names.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.updated_at IS '更新日時';


--
-- Name: COLUMN artist_names.artist_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.artist_id IS 'アーティストID';


--
-- Name: COLUMN artist_names.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.name IS 'アーティストの名義（本名義または別名義）';


--
-- Name: COLUMN artist_names.name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.name_reading IS '名義の読み方';


--
-- Name: COLUMN artist_names.is_main_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.is_main_name IS 'この名義が本名義かどうか(trueの場合、本名義)';


--
-- Name: COLUMN artist_names.first_character_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.first_character_type IS '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';


--
-- Name: COLUMN artist_names.first_character; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.first_character IS '頭文字詳細(英字、ひらがな、カタカナの場合のみ)';


--
-- Name: COLUMN artist_names.first_character_row; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.first_character_row IS '頭文字の行 (ひらがな、カタカナの場合のみ)';


--
-- Name: COLUMN artist_names.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.description IS '説明';


--
-- Name: COLUMN artist_names.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.note IS '備考';


--
-- Name: COLUMN artist_names.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.published_at IS '公開日時';


--
-- Name: COLUMN artist_names.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_names.archived_at IS 'アーカイブ日時';


--
-- Name: artist_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    description text,
    note text
);


--
-- Name: TABLE artist_roles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.artist_roles IS 'アーティストが担う役割(作曲/編曲など)を定義するテーブル';


--
-- Name: COLUMN artist_roles.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.id IS 'アーティスト役割ID';


--
-- Name: COLUMN artist_roles.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.created_at IS '作成日時';


--
-- Name: COLUMN artist_roles.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.updated_at IS '更新日時';


--
-- Name: COLUMN artist_roles.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.name IS '役割名 (vocalist, composer, arranger, rearranger, lyricistなど)';


--
-- Name: COLUMN artist_roles.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.display_name IS '表示名';


--
-- Name: COLUMN artist_roles.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.description IS '役割の説明';


--
-- Name: COLUMN artist_roles.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artist_roles.note IS '備考';


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    note text
);


--
-- Name: TABLE artists; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.artists IS 'アーティスト本体。名義はartist_namesで細かく管理';


--
-- Name: COLUMN artists.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artists.id IS 'アーティストID';


--
-- Name: COLUMN artists.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artists.created_at IS '作成日時';


--
-- Name: COLUMN artists.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artists.updated_at IS '更新日時';


--
-- Name: COLUMN artists.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artists.name IS '管理名';


--
-- Name: COLUMN artists.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.artists.note IS '備考';


--
-- Name: circles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.circles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    name_reading text,
    slug text DEFAULT gen_random_uuid() NOT NULL,
    first_character_type public.first_character_type NOT NULL,
    first_character text,
    first_character_row text,
    description text,
    note text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    CONSTRAINT circles_check CHECK ((((first_character_type = ANY (ARRAY['alphabet'::public.first_character_type, 'hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['alphabet'::public.first_character_type, 'hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character IS NULL)))),
    CONSTRAINT circles_check1 CHECK ((((first_character_type = ANY (ARRAY['hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character_row IS NOT NULL)) OR ((first_character_type <> ALL (ARRAY['hiragana'::public.first_character_type, 'katakana'::public.first_character_type])) AND (first_character_row IS NULL))))
);


--
-- Name: TABLE circles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.circles IS 'サークル情報（同人音楽サークルなど）を管理';


--
-- Name: COLUMN circles.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.id IS 'サークルID';


--
-- Name: COLUMN circles.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.created_at IS '作成日時';


--
-- Name: COLUMN circles.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.updated_at IS '更新日時';


--
-- Name: COLUMN circles.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.name IS '名前';


--
-- Name: COLUMN circles.name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.name_reading IS '名前読み方';


--
-- Name: COLUMN circles.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.slug IS 'スラッグ';


--
-- Name: COLUMN circles.first_character_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.first_character_type IS '頭文字の文字種別(symbol,number,alphabet,kana,kanji,other)';


--
-- Name: COLUMN circles.first_character; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.first_character IS '頭文字詳細(英字、ひらがな、カタカナの場合のみ)';


--
-- Name: COLUMN circles.first_character_row; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.first_character_row IS '頭文字の行 (ひらがな、カタカナの場合のみ)';


--
-- Name: COLUMN circles.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.description IS '説明';


--
-- Name: COLUMN circles.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.note IS '備考';


--
-- Name: COLUMN circles.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.published_at IS '公開日時';


--
-- Name: COLUMN circles.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.circles.archived_at IS 'アーカイブ日時';


--
-- Name: distribution_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distribution_services (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    service_name text NOT NULL,
    display_name text NOT NULL,
    base_urls jsonb NOT NULL,
    description text,
    note text,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE distribution_services; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.distribution_services IS '音楽配信サービス（Spotify, Apple Music等）の基本情報を管理';


--
-- Name: COLUMN distribution_services.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.id IS '配信サービスID';


--
-- Name: COLUMN distribution_services.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.created_at IS '作成日時';


--
-- Name: COLUMN distribution_services.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.updated_at IS '更新日時';


--
-- Name: COLUMN distribution_services.service_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.service_name IS 'サービス名';


--
-- Name: COLUMN distribution_services.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.display_name IS '表示名';


--
-- Name: COLUMN distribution_services.base_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.base_urls IS 'サービスのベースURLの配列（["https://open.spotify.com/"]）';


--
-- Name: COLUMN distribution_services.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.description IS '説明';


--
-- Name: COLUMN distribution_services.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.distribution_services.note IS '備考';


--
-- Name: event_days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_days (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    event_edition_id uuid NOT NULL,
    day_number integer,
    display_name text,
    event_date date,
    region_code text DEFAULT 'JP'::text NOT NULL,
    is_cancelled boolean DEFAULT false NOT NULL,
    is_online boolean DEFAULT false NOT NULL,
    description text,
    note text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE event_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.event_days IS 'イベント開催回内の日程（複数日開催の場合など）を管理';


--
-- Name: COLUMN event_days.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.id IS 'イベント日程ID';


--
-- Name: COLUMN event_days.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.created_at IS '作成日時';


--
-- Name: COLUMN event_days.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.updated_at IS '更新日時';


--
-- Name: COLUMN event_days.event_edition_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.event_edition_id IS 'イベント開催回ID';


--
-- Name: COLUMN event_days.day_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.day_number IS '日程の順序';


--
-- Name: COLUMN event_days.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.display_name IS '表示名';


--
-- Name: COLUMN event_days.event_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.event_date IS '開催日';


--
-- Name: COLUMN event_days.region_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.region_code IS '地域コード オンラインの場合はGlobal/default: JP';


--
-- Name: COLUMN event_days.is_cancelled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.is_cancelled IS '中止か否か';


--
-- Name: COLUMN event_days.is_online; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.is_online IS 'オンライン開催か否か';


--
-- Name: COLUMN event_days.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.description IS '説明';


--
-- Name: COLUMN event_days.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.note IS '備考';


--
-- Name: COLUMN event_days.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.published_at IS '公開日時';


--
-- Name: COLUMN event_days.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days.archived_at IS 'アーカイブ日時';


--
-- Name: COLUMN event_days."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_days."position" IS '順序';


--
-- Name: event_editions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_editions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    event_series_id uuid NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    display_name_reading text,
    slug text DEFAULT gen_random_uuid() NOT NULL,
    start_date date,
    end_date date,
    touhou_date date,
    description text,
    note text,
    url text,
    twitter_url text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE event_editions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.event_editions IS 'イベントシリーズの特定開催回(例: コミケ〇〇回)を管理';


--
-- Name: COLUMN event_editions.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.id IS 'イベント開催回ID';


--
-- Name: COLUMN event_editions.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.created_at IS '作成日時';


--
-- Name: COLUMN event_editions.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.updated_at IS '更新日時';


--
-- Name: COLUMN event_editions.event_series_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.event_series_id IS 'イベントシリーズID';


--
-- Name: COLUMN event_editions.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.name IS '管理名';


--
-- Name: COLUMN event_editions.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.display_name IS '表示名';


--
-- Name: COLUMN event_editions.display_name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.display_name_reading IS '表示名読み仮名';


--
-- Name: COLUMN event_editions.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.slug IS 'スラッグ';


--
-- Name: COLUMN event_editions.start_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.start_date IS '開始日';


--
-- Name: COLUMN event_editions.end_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.end_date IS '終了日';


--
-- Name: COLUMN event_editions.touhou_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.touhou_date IS '東方Projectの開催日(コミケの場合のみ使用する)';


--
-- Name: COLUMN event_editions.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.description IS '説明';


--
-- Name: COLUMN event_editions.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.note IS '備考';


--
-- Name: COLUMN event_editions.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.url IS 'URL';


--
-- Name: COLUMN event_editions.twitter_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.twitter_url IS 'Twitter URL';


--
-- Name: COLUMN event_editions.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.published_at IS '公開日時';


--
-- Name: COLUMN event_editions.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_editions.archived_at IS 'アーカイブ日時';


--
-- Name: event_series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_series (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    display_name_reading text,
    slug text DEFAULT gen_random_uuid() NOT NULL,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE event_series; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.event_series IS 'イベントシリーズ';


--
-- Name: COLUMN event_series.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.id IS 'イベントシリーズID';


--
-- Name: COLUMN event_series.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.created_at IS '作成日時';


--
-- Name: COLUMN event_series.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.updated_at IS '更新日時';


--
-- Name: COLUMN event_series.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.name IS '管理名';


--
-- Name: COLUMN event_series.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.display_name IS '表示名';


--
-- Name: COLUMN event_series.display_name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.display_name_reading IS '表示名読み仮名';


--
-- Name: COLUMN event_series.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.slug IS 'スラッグ';


--
-- Name: COLUMN event_series.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.published_at IS '公開日時';


--
-- Name: COLUMN event_series.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.event_series.archived_at IS 'アーカイブ日時';


--
-- Name: genreable_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genreable_genres (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    genreable_type text NOT NULL,
    genreable_id uuid NOT NULL,
    genre_id uuid NOT NULL,
    locked_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL,
    CONSTRAINT genreable_genres_genreable_type_check CHECK ((genreable_type = ANY (ARRAY['Album'::text, 'Circle'::text, 'ArtistName'::text])))
);


--
-- Name: TABLE genreable_genres; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.genreable_genres IS 'アルバム、サークル、アーティストなどにジャンルを割り当てる中間テーブル';


--
-- Name: COLUMN genreable_genres.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.id IS 'エンティティジャンルID';


--
-- Name: COLUMN genreable_genres.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.created_at IS '作成日時';


--
-- Name: COLUMN genreable_genres.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.updated_at IS '更新日時';


--
-- Name: COLUMN genreable_genres.genreable_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.genreable_type IS '対象の種別（Album, Circle, ArtistNameのいずれか）';


--
-- Name: COLUMN genreable_genres.genreable_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.genreable_id IS '対象のID（アルバムID、サークルID、アーティストネームID）';


--
-- Name: COLUMN genreable_genres.genre_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.genre_id IS '割り当てるジャンルID';


--
-- Name: COLUMN genreable_genres.locked_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genreable_genres.locked_at IS 'ジャンル付与情報をロックする日時';


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genres (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    description text,
    note text
);


--
-- Name: TABLE genres; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.genres IS 'ジャンル情報を管理するテーブル（ロック、ジャズ、エレクトロなど）';


--
-- Name: COLUMN genres.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.id IS 'ジャンルID';


--
-- Name: COLUMN genres.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.created_at IS '作成日時';


--
-- Name: COLUMN genres.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.updated_at IS '更新日時';


--
-- Name: COLUMN genres.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.name IS 'ジャンル名（ユニーク）';


--
-- Name: COLUMN genres.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.description IS 'ジャンルの簡易説明';


--
-- Name: COLUMN genres.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.genres.note IS 'ジャンルに関する補足情報';


--
-- Name: original_songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.original_songs (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    product_id text NOT NULL,
    name text NOT NULL,
    name_reading text,
    composer text,
    arranger text,
    track_number integer NOT NULL,
    is_original boolean DEFAULT false NOT NULL,
    origin_original_song_id text
);


--
-- Name: TABLE original_songs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.original_songs IS '東方Projectの原曲データ（初出曲や既存曲の再録元など）を管理';


--
-- Name: COLUMN original_songs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.id IS '原曲ID';


--
-- Name: COLUMN original_songs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.created_at IS '作成日時';


--
-- Name: COLUMN original_songs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.updated_at IS '更新日時';


--
-- Name: COLUMN original_songs.product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.product_id IS '原作ID';


--
-- Name: COLUMN original_songs.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.name IS '名前';


--
-- Name: COLUMN original_songs.name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.name_reading IS '名前読み方';


--
-- Name: COLUMN original_songs.composer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.composer IS '作曲者';


--
-- Name: COLUMN original_songs.arranger; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.arranger IS '編曲者';


--
-- Name: COLUMN original_songs.track_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.track_number IS 'トラック番号';


--
-- Name: COLUMN original_songs.is_original; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.is_original IS 'この原曲がシリーズ初登場(オリジナル)であるかを示すフラグ。trueの場合は初出のオリジナル原曲、falseの場合は既存原曲からの再録や派生版。';


--
-- Name: COLUMN original_songs.origin_original_song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.original_songs.origin_original_song_id IS '原曲元の原曲ID(同テーブル参照)';


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    name_reading text,
    short_name text NOT NULL,
    product_type public.product_type NOT NULL,
    series_number numeric(5,2) NOT NULL
);


--
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.products IS '東方Project関連の原作作品（ゲーム、CD、書籍等）を管理';


--
-- Name: COLUMN products.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.id IS '原作を一意に識別するID';


--
-- Name: COLUMN products.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.created_at IS '作成日時';


--
-- Name: COLUMN products.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.updated_at IS '更新日時';


--
-- Name: COLUMN products.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.name IS '原作作品名（正式名称）';


--
-- Name: COLUMN products.short_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.short_name IS '省略名や略称（表示用や検索用）';


--
-- Name: COLUMN products.product_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.product_type IS '作品の種類を区分する（PC-98、Windows版、商業書籍など）';


--
-- Name: COLUMN products.series_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.series_number IS 'シリーズ中での作品番号（数値順で作品を並べるために使用）';


--
-- Name: reference_urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_urls (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    referenceable_type text NOT NULL,
    referenceable_id uuid NOT NULL,
    url_type text NOT NULL,
    url text NOT NULL,
    note text,
    "position" integer DEFAULT 1 NOT NULL,
    CONSTRAINT reference_urls_referenceable_type_check CHECK ((referenceable_type = ANY (ARRAY['ArtistName'::text, 'Album'::text, 'Circle'::text, 'Song'::text])))
);


--
-- Name: TABLE reference_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.reference_urls IS 'アーティスト名やサークルに紐づく任意のURLを柔軟に格納するテーブル';


--
-- Name: COLUMN reference_urls.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.id IS 'エンティティURL ID';


--
-- Name: COLUMN reference_urls.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.created_at IS '作成日時';


--
-- Name: COLUMN reference_urls.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.updated_at IS '更新日時';


--
-- Name: COLUMN reference_urls.referenceable_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.referenceable_type IS 'リファレンス種別(ArtistName, Circle, Album, Songなど)';


--
-- Name: COLUMN reference_urls.referenceable_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.referenceable_id IS 'リファレンスID';


--
-- Name: COLUMN reference_urls.url_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.url_type IS 'URL種別(例: official, twitter, youtube, blogなど)';


--
-- Name: COLUMN reference_urls.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.url IS 'URL';


--
-- Name: COLUMN reference_urls.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls.note IS '備考';


--
-- Name: COLUMN reference_urls."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reference_urls."position" IS '順序';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: shops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    description text,
    note text,
    website_url text,
    base_urls jsonb,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE shops; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.shops IS 'CDや関連グッズを扱う各ショップ(販売店/同人ショップ)の情報を管理';


--
-- Name: COLUMN shops.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.id IS 'ショップID';


--
-- Name: COLUMN shops.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.created_at IS '作成日時';


--
-- Name: COLUMN shops.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.updated_at IS '更新日時';


--
-- Name: COLUMN shops.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.name IS '内部システムで用いるショップの識別名(ユニーク)';


--
-- Name: COLUMN shops.display_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.display_name IS '表示用のショップ名（ユーザーや外部表示用）';


--
-- Name: COLUMN shops.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.description IS 'ショップの説明';


--
-- Name: COLUMN shops.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.note IS '備考';


--
-- Name: COLUMN shops.website_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.website_url IS '公式サイトURL（ユーザーがアクセス可能なURL）';


--
-- Name: COLUMN shops.base_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.base_urls IS 'このショップに関連するベースURLリスト(json形式)';


--
-- Name: COLUMN shops.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.published_at IS '公開日時';


--
-- Name: COLUMN shops.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops.archived_at IS 'アーカイブ日時';


--
-- Name: COLUMN shops."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.shops."position" IS '順序';


--
-- Name: song_bmps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song_bmps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    bpm integer NOT NULL,
    start_time_ms bigint,
    end_time_ms bigint,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE song_bmps; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.song_bmps IS '楽曲内でのBPM情報（BPM変化箇所）を管理するテーブル';


--
-- Name: COLUMN song_bmps.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.id IS '楽曲BPMのID';


--
-- Name: COLUMN song_bmps.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.created_at IS '作成日時';


--
-- Name: COLUMN song_bmps.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.updated_at IS '更新日時';


--
-- Name: COLUMN song_bmps.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.song_id IS '楽曲ID';


--
-- Name: COLUMN song_bmps.bpm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.bpm IS 'BPM値（1分あたりのビート数）';


--
-- Name: COLUMN song_bmps.start_time_ms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.start_time_ms IS 'このBPMが適用される開始時刻(ミリ秒)';


--
-- Name: COLUMN song_bmps.end_time_ms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps.end_time_ms IS 'このBPMが適用される終了時刻(ミリ秒)';


--
-- Name: COLUMN song_bmps."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_bmps."position" IS '楽曲が持つBPMの順序';


--
-- Name: song_isrcs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song_isrcs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    isrc text NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE song_isrcs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.song_isrcs IS '楽曲に対応するISRC(国際標準レコーディングコード)を管理するテーブル';


--
-- Name: COLUMN song_isrcs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs.id IS '楽曲ISRCのID';


--
-- Name: COLUMN song_isrcs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs.created_at IS '作成日時';


--
-- Name: COLUMN song_isrcs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs.updated_at IS '更新日時';


--
-- Name: COLUMN song_isrcs.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs.song_id IS '楽曲ID';


--
-- Name: COLUMN song_isrcs.isrc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs.isrc IS 'ISRCコード（世界共通の音源識別子）';


--
-- Name: COLUMN song_isrcs."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_isrcs."position" IS '楽曲が持つISRCの順序';


--
-- Name: song_lyrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.song_lyrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    content text NOT NULL,
    language text DEFAULT 'ja'::text,
    description text,
    note text,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE song_lyrics; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.song_lyrics IS '楽曲に対応する歌詞情報を管理するテーブル';


--
-- Name: COLUMN song_lyrics.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.id IS '歌詞ID';


--
-- Name: COLUMN song_lyrics.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.created_at IS '作成日時';


--
-- Name: COLUMN song_lyrics.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.updated_at IS '更新日時';


--
-- Name: COLUMN song_lyrics.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.song_id IS '楽曲ID';


--
-- Name: COLUMN song_lyrics.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.content IS '歌詞本文';


--
-- Name: COLUMN song_lyrics.language; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.language IS '歌詞の言語コード（例: "ja" = 日本語）';


--
-- Name: COLUMN song_lyrics.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.description IS 'この歌詞に関する説明（翻訳元やバージョン違いの説明など）';


--
-- Name: COLUMN song_lyrics.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics.note IS '備考';


--
-- Name: COLUMN song_lyrics."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.song_lyrics."position" IS '楽曲が持つ歌詞の順序';


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    circle_id uuid,
    album_id uuid,
    name text NOT NULL,
    name_reading text,
    release_date date,
    release_year integer,
    release_month integer,
    slug text DEFAULT gen_random_uuid() NOT NULL,
    album_disc_id uuid,
    disc_number integer,
    track_number integer,
    length_time_ms integer,
    bpm integer,
    description text,
    note text,
    display_composer text,
    display_arranger text,
    display_rearranger text,
    display_lyricist text,
    display_vocalist text,
    display_original_song text,
    published_at timestamp with time zone,
    archived_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE songs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.songs IS '楽曲情報を管理するテーブル（アルバム収録曲や単独頒布曲などの基本情報）';


--
-- Name: COLUMN songs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.id IS '楽曲ID';


--
-- Name: COLUMN songs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.created_at IS '作成日時';


--
-- Name: COLUMN songs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.updated_at IS '更新日時';


--
-- Name: COLUMN songs.circle_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.circle_id IS 'サークルID（NULL可、あればcirclesテーブル参照）';


--
-- Name: COLUMN songs.album_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.album_id IS 'アルバムID（NULL可、あればalbumsテーブル参照）';


--
-- Name: COLUMN songs.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.name IS '楽曲名（正式タイトル）';


--
-- Name: COLUMN songs.name_reading; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.name_reading IS '名前読み方';


--
-- Name: COLUMN songs.release_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.release_date IS '頒布日(アルバムの頒布日と異なる場合に使用する)';


--
-- Name: COLUMN songs.release_year; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.release_year IS '頒布年';


--
-- Name: COLUMN songs.release_month; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.release_month IS '頒布月';


--
-- Name: COLUMN songs.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.slug IS 'URLなどで使用する一意識別子（ランダム生成された文字列）';


--
-- Name: COLUMN songs.album_disc_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.album_disc_id IS 'アルバムディスクID（NULL可、あればalbum_discsテーブル参照）';


--
-- Name: COLUMN songs.disc_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.disc_number IS 'ディスク番号';


--
-- Name: COLUMN songs.track_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.track_number IS 'トラック番号';


--
-- Name: COLUMN songs.length_time_ms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.length_time_ms IS '曲の長さ(ミリ秒)';


--
-- Name: COLUMN songs.bpm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.bpm IS 'BPM';


--
-- Name: COLUMN songs.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.description IS '楽曲に関する説明文（特徴、背景、解説など）';


--
-- Name: COLUMN songs.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.note IS 'メモや補足情報（内部用、注釈など）';


--
-- Name: COLUMN songs.display_composer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_composer IS '特定条件下で表示する作曲者名（メイン以外の名義など）';


--
-- Name: COLUMN songs.display_arranger; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_arranger IS '特定条件下で表示する編曲者名（メイン以外の名義など）';


--
-- Name: COLUMN songs.display_rearranger; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_rearranger IS '再編曲者表示名（別名義など特例的な表示用）';


--
-- Name: COLUMN songs.display_lyricist; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_lyricist IS '特定条件下で表示する作詞者名';


--
-- Name: COLUMN songs.display_vocalist; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_vocalist IS '特定条件下で表示するボーカリスト名';


--
-- Name: COLUMN songs.display_original_song; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.display_original_song IS '原曲表示用（東方以外や特殊な原曲を示す際に使用）';


--
-- Name: COLUMN songs.published_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.published_at IS '公開日時';


--
-- Name: COLUMN songs.archived_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs.archived_at IS 'アーカイブ日時';


--
-- Name: COLUMN songs."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs."position" IS '順序';


--
-- Name: songs_arrange_circles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs_arrange_circles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    circle_id uuid NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE songs_arrange_circles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.songs_arrange_circles IS '楽曲の編曲に関わったサークルを関連付けるテーブル（複数サークルが関与する場合に対応）';


--
-- Name: COLUMN songs_arrange_circles.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles.id IS '楽曲編曲サークルID';


--
-- Name: COLUMN songs_arrange_circles.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles.created_at IS '作成日時';


--
-- Name: COLUMN songs_arrange_circles.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles.updated_at IS '更新日時';


--
-- Name: COLUMN songs_arrange_circles.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles.song_id IS '楽曲ID';


--
-- Name: COLUMN songs_arrange_circles.circle_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles.circle_id IS '編曲に関わったサークルID';


--
-- Name: COLUMN songs_arrange_circles."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_arrange_circles."position" IS '編曲サークルが楽曲に対して持つ順序';


--
-- Name: songs_artist_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs_artist_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    artist_name_id uuid NOT NULL,
    artist_role_id uuid NOT NULL,
    connector text,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE songs_artist_roles; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.songs_artist_roles IS '楽曲に参加するアーティストの名義と役割（作曲、編曲、ボーカルなど）を関連付けるテーブル';


--
-- Name: COLUMN songs_artist_roles.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.id IS '主キーID';


--
-- Name: COLUMN songs_artist_roles.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.created_at IS '作成日時';


--
-- Name: COLUMN songs_artist_roles.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.updated_at IS '更新日時';


--
-- Name: COLUMN songs_artist_roles.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.song_id IS '楽曲ID';


--
-- Name: COLUMN songs_artist_roles.artist_name_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.artist_name_id IS 'アーティスト名ID（artist_namesテーブル参照、本名義・別名義を含む）';


--
-- Name: COLUMN songs_artist_roles.artist_role_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.artist_role_id IS '役割ID（artist_rolesテーブル参照）';


--
-- Name: COLUMN songs_artist_roles.connector; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles.connector IS 'アーティスト名同士を結ぶ接続詞（"vs"、"feat."など）';


--
-- Name: COLUMN songs_artist_roles."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_artist_roles."position" IS 'アーティストが曲に参加する順序';


--
-- Name: songs_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs_genres (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    genre_id uuid NOT NULL,
    start_time_ms bigint,
    end_time_ms bigint,
    locked_at timestamp with time zone,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE songs_genres; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.songs_genres IS '楽曲に紐づくジャンル情報を管理する中間テーブル（開始位置・終了位置で曲中の特定区間を示すことも可能）';


--
-- Name: COLUMN songs_genres.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.id IS '楽曲ジャンルID';


--
-- Name: COLUMN songs_genres.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.created_at IS '作成日時';


--
-- Name: COLUMN songs_genres.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.updated_at IS '更新日時';


--
-- Name: COLUMN songs_genres.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.song_id IS '楽曲ID';


--
-- Name: COLUMN songs_genres.genre_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.genre_id IS 'ジャンルID';


--
-- Name: COLUMN songs_genres.start_time_ms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.start_time_ms IS 'このジャンルが適用される楽曲内の開始時刻(ミリ秒)';


--
-- Name: COLUMN songs_genres.end_time_ms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.end_time_ms IS 'このジャンルが適用される楽曲内の終了時刻(ミリ秒)';


--
-- Name: COLUMN songs_genres.locked_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres.locked_at IS 'ジャンル情報を固定する日時（再編集不可などの運用制約に使用）';


--
-- Name: COLUMN songs_genres."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_genres."position" IS '楽曲が持つジャンルの順序';


--
-- Name: songs_original_songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs_original_songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    song_id uuid NOT NULL,
    original_song_id text NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: TABLE songs_original_songs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.songs_original_songs IS '楽曲と原曲の関連付けテーブル。1つの楽曲が複数の原曲を元にしている場合に対応可能';


--
-- Name: COLUMN songs_original_songs.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs.id IS '楽曲原曲ID';


--
-- Name: COLUMN songs_original_songs.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs.created_at IS '作成日時';


--
-- Name: COLUMN songs_original_songs.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs.updated_at IS '更新日時';


--
-- Name: COLUMN songs_original_songs.song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs.song_id IS '楽曲ID';


--
-- Name: COLUMN songs_original_songs.original_song_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs.original_song_id IS '元になった原曲ID（original_songsテーブル参照）';


--
-- Name: COLUMN songs_original_songs."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.songs_original_songs."position" IS '楽曲が原曲に対して持つ順序';


--
-- Name: streamable_urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.streamable_urls (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    streamable_type text NOT NULL,
    streamable_id text NOT NULL,
    service_name text NOT NULL,
    url text NOT NULL,
    description text,
    note text,
    "position" integer DEFAULT 1 NOT NULL,
    CONSTRAINT streamable_urls_streamable_type_check CHECK ((streamable_type = ANY (ARRAY['Product'::text, 'OriginalSong'::text, 'Album'::text, 'Song'::text])))
);


--
-- Name: TABLE streamable_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.streamable_urls IS '原作・原曲・アルバム・楽曲ごとに各配信サービスでのURLを管理';


--
-- Name: COLUMN streamable_urls.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.id IS '配信サービスURLのID';


--
-- Name: COLUMN streamable_urls.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.created_at IS '作成日時';


--
-- Name: COLUMN streamable_urls.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.updated_at IS '更新日時';


--
-- Name: COLUMN streamable_urls.streamable_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.streamable_type IS 'ストリーミング可能なエンティティのタイプ（原作、原曲、アルバム、楽曲）';


--
-- Name: COLUMN streamable_urls.streamable_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.streamable_id IS 'ストリーミング可能なエンティティのID（原作ID、原曲ID、アルバムID、楽曲ID）';


--
-- Name: COLUMN streamable_urls.service_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.service_name IS '配信サービスの名称';


--
-- Name: COLUMN streamable_urls.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.url IS 'URL';


--
-- Name: COLUMN streamable_urls.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.description IS '説明';


--
-- Name: COLUMN streamable_urls.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls.note IS '備考';


--
-- Name: COLUMN streamable_urls."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.streamable_urls."position" IS '順序';


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    taggable_type text NOT NULL,
    taggable_id uuid NOT NULL,
    tag_id uuid NOT NULL,
    locked_at timestamp with time zone,
    CONSTRAINT taggings_taggable_type_check CHECK ((taggable_type = ANY (ARRAY['Album'::text, 'Song'::text, 'Circle'::text, 'ArtistName'::text])))
);


--
-- Name: TABLE taggings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.taggings IS 'アルバム、楽曲、サークル、アーティストなど任意のエンティティにタグを付ける中間テーブル';


--
-- Name: COLUMN taggings.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.id IS 'タグ付けID';


--
-- Name: COLUMN taggings.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.created_at IS '作成日時';


--
-- Name: COLUMN taggings.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.updated_at IS '更新日時';


--
-- Name: COLUMN taggings.taggable_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.taggable_type IS '対象の種別（Album, Song, Circle, ArtistName）';


--
-- Name: COLUMN taggings.taggable_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.taggable_id IS 'タグ付け対象のID';


--
-- Name: COLUMN taggings.tag_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.tag_id IS '付与するタグID';


--
-- Name: COLUMN taggings.locked_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.taggings.locked_at IS 'タグ付与情報をロックする日時';


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name text NOT NULL,
    description text,
    note text
);


--
-- Name: TABLE tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.tags IS 'タグ情報を管理するテーブル。ジャンル以外の属性や特徴を自由に付与可能';


--
-- Name: COLUMN tags.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.id IS 'タグID';


--
-- Name: COLUMN tags.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.created_at IS '作成日時';


--
-- Name: COLUMN tags.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.updated_at IS '更新日時';


--
-- Name: COLUMN tags.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.name IS 'タグ名（ユニーク）';


--
-- Name: COLUMN tags.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.description IS 'タグに関する説明文';


--
-- Name: COLUMN tags.note; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tags.note IS 'タグに関する補足情報';


--
-- Name: album_discs album_discs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_discs
    ADD CONSTRAINT album_discs_pkey PRIMARY KEY (id);


--
-- Name: album_prices album_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_prices
    ADD CONSTRAINT album_prices_pkey PRIMARY KEY (id);


--
-- Name: album_upcs album_upcs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_upcs
    ADD CONSTRAINT album_upcs_pkey PRIMARY KEY (id);


--
-- Name: albums_circles albums_circles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums_circles
    ADD CONSTRAINT albums_circles_pkey PRIMARY KEY (id);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: albums albums_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_slug_key UNIQUE (slug);


--
-- Name: artist_names artist_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_names
    ADD CONSTRAINT artist_names_pkey PRIMARY KEY (id);


--
-- Name: artist_roles artist_roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_roles
    ADD CONSTRAINT artist_roles_name_key UNIQUE (name);


--
-- Name: artist_roles artist_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_roles
    ADD CONSTRAINT artist_roles_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: circles circles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.circles
    ADD CONSTRAINT circles_pkey PRIMARY KEY (id);


--
-- Name: circles circles_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.circles
    ADD CONSTRAINT circles_slug_key UNIQUE (slug);


--
-- Name: distribution_services distribution_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distribution_services
    ADD CONSTRAINT distribution_services_pkey PRIMARY KEY (id);


--
-- Name: distribution_services distribution_services_service_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distribution_services
    ADD CONSTRAINT distribution_services_service_name_key UNIQUE (service_name);


--
-- Name: event_days event_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_days
    ADD CONSTRAINT event_days_pkey PRIMARY KEY (id);


--
-- Name: event_editions event_editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_editions
    ADD CONSTRAINT event_editions_pkey PRIMARY KEY (id);


--
-- Name: event_editions event_editions_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_editions
    ADD CONSTRAINT event_editions_slug_key UNIQUE (slug);


--
-- Name: event_series event_series_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_series
    ADD CONSTRAINT event_series_name_key UNIQUE (name);


--
-- Name: event_series event_series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_series
    ADD CONSTRAINT event_series_pkey PRIMARY KEY (id);


--
-- Name: event_series event_series_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_series
    ADD CONSTRAINT event_series_slug_key UNIQUE (slug);


--
-- Name: genreable_genres genreable_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genreable_genres
    ADD CONSTRAINT genreable_genres_pkey PRIMARY KEY (id);


--
-- Name: genres genres_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_name_key UNIQUE (name);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: original_songs original_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.original_songs
    ADD CONSTRAINT original_songs_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reference_urls reference_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_urls
    ADD CONSTRAINT reference_urls_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shops shops_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_name_key UNIQUE (name);


--
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- Name: song_bmps song_bmps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_bmps
    ADD CONSTRAINT song_bmps_pkey PRIMARY KEY (id);


--
-- Name: song_isrcs song_isrcs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_isrcs
    ADD CONSTRAINT song_isrcs_pkey PRIMARY KEY (id);


--
-- Name: song_lyrics song_lyrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_lyrics
    ADD CONSTRAINT song_lyrics_pkey PRIMARY KEY (id);


--
-- Name: songs_arrange_circles songs_arrange_circles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_arrange_circles
    ADD CONSTRAINT songs_arrange_circles_pkey PRIMARY KEY (id);


--
-- Name: songs_artist_roles songs_artist_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_artist_roles
    ADD CONSTRAINT songs_artist_roles_pkey PRIMARY KEY (id);


--
-- Name: songs_genres songs_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT songs_genres_pkey PRIMARY KEY (id);


--
-- Name: songs_original_songs songs_original_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_original_songs
    ADD CONSTRAINT songs_original_songs_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: songs songs_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_slug_key UNIQUE (slug);


--
-- Name: streamable_urls streamable_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.streamable_urls
    ADD CONSTRAINT streamable_urls_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_name_key UNIQUE (name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: idx_album_discs_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_discs_album_id ON public.album_discs USING btree (album_id);


--
-- Name: idx_album_discs_disc_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_discs_disc_number ON public.album_discs USING btree (disc_number);


--
-- Name: idx_album_discs_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_discs_position ON public.album_discs USING btree ("position");


--
-- Name: idx_album_prices_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_album_id ON public.album_prices USING btree (album_id);


--
-- Name: idx_album_prices_album_id_price_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_album_id_price_type ON public.album_prices USING btree (album_id, price_type);


--
-- Name: idx_album_prices_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_position ON public.album_prices USING btree ("position");


--
-- Name: idx_album_prices_price_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_price_type ON public.album_prices USING btree (price_type);


--
-- Name: idx_album_prices_shop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_shop_id ON public.album_prices USING btree (shop_id);


--
-- Name: idx_album_prices_shop_id_price_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_prices_shop_id_price_type ON public.album_prices USING btree (shop_id, price_type);


--
-- Name: idx_album_upcs_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_upcs_album_id ON public.album_upcs USING btree (album_id);


--
-- Name: idx_album_upcs_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_album_upcs_position ON public.album_upcs USING btree ("position");


--
-- Name: idx_albums_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_archived_at ON public.albums USING btree (archived_at);


--
-- Name: idx_albums_circles_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_circles_album_id ON public.albums_circles USING btree (album_id);


--
-- Name: idx_albums_circles_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_circles_circle_id ON public.albums_circles USING btree (circle_id);


--
-- Name: idx_albums_circles_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_circles_position ON public.albums_circles USING btree ("position");


--
-- Name: idx_albums_event_day_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_event_day_id ON public.albums USING btree (event_day_id);


--
-- Name: idx_albums_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_position ON public.albums USING btree ("position");


--
-- Name: idx_albums_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_published_at ON public.albums USING btree (published_at);


--
-- Name: idx_albums_release_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_circle_id ON public.albums USING btree (release_circle_id);


--
-- Name: idx_albums_release_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_date ON public.albums USING btree (release_date);


--
-- Name: idx_albums_release_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_month ON public.albums USING btree (release_month);


--
-- Name: idx_albums_release_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_year ON public.albums USING btree (release_year);


--
-- Name: idx_albums_release_year_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_albums_release_year_month ON public.albums USING btree (release_year, release_month);


--
-- Name: idx_artist_names_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_artist_names_archived_at ON public.artist_names USING btree (archived_at);


--
-- Name: idx_artist_names_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_artist_names_artist_id ON public.artist_names USING btree (artist_id);


--
-- Name: idx_artist_names_first_character; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_artist_names_first_character ON public.artist_names USING btree (first_character_type, first_character);


--
-- Name: idx_artist_names_first_character_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_artist_names_first_character_type ON public.artist_names USING btree (first_character_type);


--
-- Name: idx_artist_names_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_artist_names_published_at ON public.artist_names USING btree (published_at);


--
-- Name: idx_circles_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_circles_archived_at ON public.circles USING btree (archived_at);


--
-- Name: idx_circles_first_character; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_circles_first_character ON public.circles USING btree (first_character_type, first_character);


--
-- Name: idx_circles_first_character_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_circles_first_character_type ON public.circles USING btree (first_character_type);


--
-- Name: idx_circles_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_circles_published_at ON public.circles USING btree (published_at);


--
-- Name: idx_distribution_services_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_distribution_services_position ON public.distribution_services USING btree ("position");


--
-- Name: idx_event_days_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_archived_at ON public.event_days USING btree (archived_at);


--
-- Name: idx_event_days_event_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_event_date ON public.event_days USING btree (event_date);


--
-- Name: idx_event_days_event_edition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_event_edition_id ON public.event_days USING btree (event_edition_id);


--
-- Name: idx_event_days_is_cancelled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_is_cancelled ON public.event_days USING btree (is_cancelled);


--
-- Name: idx_event_days_is_online; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_is_online ON public.event_days USING btree (is_online);


--
-- Name: idx_event_days_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_position ON public.event_days USING btree ("position");


--
-- Name: idx_event_days_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_published_at ON public.event_days USING btree (published_at);


--
-- Name: idx_event_days_region_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_days_region_code ON public.event_days USING btree (region_code);


--
-- Name: idx_event_editions_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_archived_at ON public.event_editions USING btree (archived_at);


--
-- Name: idx_event_editions_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_end_date ON public.event_editions USING btree (end_date);


--
-- Name: idx_event_editions_event_series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_event_series_id ON public.event_editions USING btree (event_series_id);


--
-- Name: idx_event_editions_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_position ON public.event_editions USING btree ("position");


--
-- Name: idx_event_editions_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_published_at ON public.event_editions USING btree (published_at);


--
-- Name: idx_event_editions_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_start_date ON public.event_editions USING btree (start_date);


--
-- Name: idx_event_editions_touhou_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_editions_touhou_date ON public.event_editions USING btree (touhou_date);


--
-- Name: idx_event_series_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_series_archived_at ON public.event_series USING btree (archived_at);


--
-- Name: idx_event_series_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_series_position ON public.event_series USING btree ("position");


--
-- Name: idx_event_series_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_series_published_at ON public.event_series USING btree (published_at);


--
-- Name: idx_genreable_genres_locked_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_genreable_genres_locked_at ON public.genreable_genres USING btree (locked_at);


--
-- Name: idx_genreable_genres_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_genreable_genres_position ON public.genreable_genres USING btree ("position");


--
-- Name: idx_original_songs_is_original; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_original_songs_is_original ON public.original_songs USING btree (is_original);


--
-- Name: idx_original_songs_origin_original_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_original_songs_origin_original_song_id ON public.original_songs USING btree (origin_original_song_id);


--
-- Name: idx_original_songs_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_original_songs_product_id ON public.original_songs USING btree (product_id);


--
-- Name: idx_original_songs_track_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_original_songs_track_number ON public.original_songs USING btree (track_number);


--
-- Name: idx_products_product_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_product_type ON public.products USING btree (product_type);


--
-- Name: idx_products_series_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_series_number ON public.products USING btree (series_number);


--
-- Name: idx_reference_urls_referenceable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reference_urls_referenceable ON public.reference_urls USING btree (referenceable_type, referenceable_id);


--
-- Name: idx_reference_urls_url_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reference_urls_url_type ON public.reference_urls USING btree (url_type);


--
-- Name: idx_shops_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_archived_at ON public.shops USING btree (archived_at);


--
-- Name: idx_shops_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_position ON public.shops USING btree ("position");


--
-- Name: idx_shops_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shops_published_at ON public.shops USING btree (published_at);


--
-- Name: idx_song_bmps_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_bmps_position ON public.song_bmps USING btree ("position");


--
-- Name: idx_song_bmps_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_bmps_song_id ON public.song_bmps USING btree (song_id);


--
-- Name: idx_song_isrcs_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_isrcs_position ON public.song_isrcs USING btree ("position");


--
-- Name: idx_song_isrcs_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_isrcs_song_id ON public.song_isrcs USING btree (song_id);


--
-- Name: idx_song_lyrics_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_lyrics_position ON public.song_lyrics USING btree ("position");


--
-- Name: idx_song_lyrics_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_song_lyrics_song_id ON public.song_lyrics USING btree (song_id);


--
-- Name: idx_songs_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_album_id ON public.songs USING btree (album_id);


--
-- Name: idx_songs_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_archived_at ON public.songs USING btree (archived_at);


--
-- Name: idx_songs_arrange_circles_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_arrange_circles_circle_id ON public.songs_arrange_circles USING btree (circle_id);


--
-- Name: idx_songs_arrange_circles_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_arrange_circles_position ON public.songs_arrange_circles USING btree ("position");


--
-- Name: idx_songs_arrange_circles_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_arrange_circles_song_id ON public.songs_arrange_circles USING btree (song_id);


--
-- Name: idx_songs_artist_roles_artist_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_artist_roles_artist_name_id ON public.songs_artist_roles USING btree (artist_name_id);


--
-- Name: idx_songs_artist_roles_artist_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_artist_roles_artist_role_id ON public.songs_artist_roles USING btree (artist_role_id);


--
-- Name: idx_songs_artist_roles_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_artist_roles_position ON public.songs_artist_roles USING btree ("position");


--
-- Name: idx_songs_artist_roles_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_artist_roles_song_id ON public.songs_artist_roles USING btree (song_id);


--
-- Name: idx_songs_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_circle_id ON public.songs USING btree (circle_id);


--
-- Name: idx_songs_genres_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_genres_genre_id ON public.songs_genres USING btree (genre_id);


--
-- Name: idx_songs_genres_locked_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_genres_locked_at ON public.songs_genres USING btree (locked_at);


--
-- Name: idx_songs_genres_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_genres_position ON public.songs_genres USING btree ("position");


--
-- Name: idx_songs_genres_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_genres_song_id ON public.songs_genres USING btree (song_id);


--
-- Name: idx_songs_genres_song_id_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_genres_song_id_genre_id ON public.songs_genres USING btree (song_id, genre_id);


--
-- Name: idx_songs_original_songs_original_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_original_songs_original_song_id ON public.songs_original_songs USING btree (original_song_id);


--
-- Name: idx_songs_original_songs_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_original_songs_position ON public.songs_original_songs USING btree ("position");


--
-- Name: idx_songs_original_songs_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_original_songs_song_id ON public.songs_original_songs USING btree (song_id);


--
-- Name: idx_songs_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_position ON public.songs USING btree ("position");


--
-- Name: idx_songs_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_published_at ON public.songs USING btree (published_at);


--
-- Name: idx_songs_release_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_release_date ON public.songs USING btree (release_date);


--
-- Name: idx_songs_release_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_release_month ON public.songs USING btree (release_month);


--
-- Name: idx_songs_release_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_release_year ON public.songs USING btree (release_year);


--
-- Name: idx_songs_release_year_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_songs_release_year_month ON public.songs USING btree (release_year, release_month);


--
-- Name: idx_streamable_urls_service_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_streamable_urls_service_name ON public.streamable_urls USING btree (service_name);


--
-- Name: idx_taggings_locked_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_taggings_locked_at ON public.taggings USING btree (locked_at);


--
-- Name: uk_album_upcs_album_id_upc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_album_upcs_album_id_upc ON public.album_upcs USING btree (album_id, upc);


--
-- Name: uk_albums_circles_album_id_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_albums_circles_album_id_circle_id ON public.albums_circles USING btree (album_id, circle_id);


--
-- Name: uk_ap_album_id_shop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_ap_album_id_shop_id ON public.album_prices USING btree (album_id, shop_id);


--
-- Name: uk_artist_names_artist_id_main_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_artist_names_artist_id_main_name ON public.artist_names USING btree (artist_id, is_main_name) WHERE (is_main_name = true);


--
-- Name: uk_circles_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_circles_name ON public.circles USING btree (name);


--
-- Name: uk_event_days_event_edition_id_day_number_is_online; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_event_days_event_edition_id_day_number_is_online ON public.event_days USING btree (event_edition_id, day_number, is_online);


--
-- Name: uk_event_editions_event_series_id_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_event_editions_event_series_id_name ON public.event_editions USING btree (event_series_id, name);


--
-- Name: uk_genreable_genres_genreable_type_genreable_id_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_genreable_genres_genreable_type_genreable_id_genre_id ON public.genreable_genres USING btree (genreable_type, genreable_id, genre_id);


--
-- Name: uk_reference_urls_referenceable_type_referenceable_id_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_reference_urls_referenceable_type_referenceable_id_url ON public.reference_urls USING btree (referenceable_type, referenceable_id, url);


--
-- Name: uk_sar_song_id_artist_name_id_artist_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_sar_song_id_artist_name_id_artist_role_id ON public.songs_artist_roles USING btree (song_id, artist_name_id, artist_role_id);


--
-- Name: uk_song_isrcs_song_id_isrc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_song_isrcs_song_id_isrc ON public.song_isrcs USING btree (song_id, isrc);


--
-- Name: uk_songs_arrange_circles_song_id_circle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_songs_arrange_circles_song_id_circle_id ON public.songs_arrange_circles USING btree (song_id, circle_id);


--
-- Name: uk_songs_original_songs_song_id_original_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_songs_original_songs_song_id_original_song_id ON public.songs_original_songs USING btree (song_id, original_song_id);


--
-- Name: uk_streamable_urls_streamable_id_service; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_streamable_urls_streamable_id_service ON public.streamable_urls USING btree (streamable_type, streamable_id, service_name);


--
-- Name: uk_taggings_taggable; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_taggings_taggable ON public.taggings USING btree (taggable_type, taggable_id, tag_id);


--
-- Name: album_discs album_discs_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_discs
    ADD CONSTRAINT album_discs_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: album_prices album_prices_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_prices
    ADD CONSTRAINT album_prices_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: album_prices album_prices_shop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_prices
    ADD CONSTRAINT album_prices_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shops(id) ON DELETE RESTRICT;


--
-- Name: album_upcs album_upcs_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album_upcs
    ADD CONSTRAINT album_upcs_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: albums_circles albums_circles_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums_circles
    ADD CONSTRAINT albums_circles_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: albums_circles albums_circles_circle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums_circles
    ADD CONSTRAINT albums_circles_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES public.circles(id) ON DELETE CASCADE;


--
-- Name: albums albums_event_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_event_day_id_fkey FOREIGN KEY (event_day_id) REFERENCES public.event_days(id) ON DELETE SET NULL;


--
-- Name: albums albums_release_circle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_release_circle_id_fkey FOREIGN KEY (release_circle_id) REFERENCES public.circles(id) ON DELETE RESTRICT;


--
-- Name: artist_names artist_names_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_names
    ADD CONSTRAINT artist_names_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id) ON DELETE CASCADE;


--
-- Name: event_days event_days_event_edition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_days
    ADD CONSTRAINT event_days_event_edition_id_fkey FOREIGN KEY (event_edition_id) REFERENCES public.event_editions(id) ON DELETE CASCADE;


--
-- Name: event_editions event_editions_event_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_editions
    ADD CONSTRAINT event_editions_event_series_id_fkey FOREIGN KEY (event_series_id) REFERENCES public.event_series(id) ON DELETE RESTRICT;


--
-- Name: genreable_genres genreable_genres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genreable_genres
    ADD CONSTRAINT genreable_genres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE CASCADE;


--
-- Name: original_songs original_songs_origin_original_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.original_songs
    ADD CONSTRAINT original_songs_origin_original_song_id_fkey FOREIGN KEY (origin_original_song_id) REFERENCES public.original_songs(id) ON DELETE SET NULL;


--
-- Name: original_songs original_songs_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.original_songs
    ADD CONSTRAINT original_songs_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: song_bmps song_bmps_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_bmps
    ADD CONSTRAINT song_bmps_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: song_isrcs song_isrcs_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_isrcs
    ADD CONSTRAINT song_isrcs_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: song_lyrics song_lyrics_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.song_lyrics
    ADD CONSTRAINT song_lyrics_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: songs songs_album_disc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_album_disc_id_fkey FOREIGN KEY (album_disc_id) REFERENCES public.album_discs(id) ON DELETE SET NULL;


--
-- Name: songs songs_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE RESTRICT;


--
-- Name: songs_arrange_circles songs_arrange_circles_circle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_arrange_circles
    ADD CONSTRAINT songs_arrange_circles_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES public.circles(id) ON DELETE CASCADE;


--
-- Name: songs_arrange_circles songs_arrange_circles_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_arrange_circles
    ADD CONSTRAINT songs_arrange_circles_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: songs_artist_roles songs_artist_roles_artist_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_artist_roles
    ADD CONSTRAINT songs_artist_roles_artist_name_id_fkey FOREIGN KEY (artist_name_id) REFERENCES public.artist_names(id) ON DELETE CASCADE;


--
-- Name: songs_artist_roles songs_artist_roles_artist_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_artist_roles
    ADD CONSTRAINT songs_artist_roles_artist_role_id_fkey FOREIGN KEY (artist_role_id) REFERENCES public.artist_roles(id) ON DELETE CASCADE;


--
-- Name: songs_artist_roles songs_artist_roles_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_artist_roles
    ADD CONSTRAINT songs_artist_roles_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: songs songs_circle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES public.circles(id) ON DELETE RESTRICT;


--
-- Name: songs_genres songs_genres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT songs_genres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE CASCADE;


--
-- Name: songs_genres songs_genres_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_genres
    ADD CONSTRAINT songs_genres_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: songs_original_songs songs_original_songs_original_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_original_songs
    ADD CONSTRAINT songs_original_songs_original_song_id_fkey FOREIGN KEY (original_song_id) REFERENCES public.original_songs(id) ON DELETE CASCADE;


--
-- Name: songs_original_songs songs_original_songs_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs_original_songs
    ADD CONSTRAINT songs_original_songs_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id) ON DELETE CASCADE;


--
-- Name: streamable_urls streamable_urls_service_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.streamable_urls
    ADD CONSTRAINT streamable_urls_service_name_fkey FOREIGN KEY (service_name) REFERENCES public.distribution_services(service_name) ON DELETE RESTRICT;


--
-- Name: taggings taggings_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20250118055109');
