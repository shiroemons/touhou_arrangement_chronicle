# public.songs_original_songs

## Description

楽曲原曲

## Columns

| Name | Type | Default | Nullable | Children | Parents | Comment |
| ---- | ---- | ------- | -------- | -------- | ------- | ------- |
| song_id | text |  | false |  | [public.songs](public.songs.md) | 楽曲ID |
| original_song_id | text |  | false |  | [public.original_songs](public.original_songs.md) | 原曲ID |
| created_at | timestamp with time zone | CURRENT_TIMESTAMP | false |  |  | 作成日時 |
| updated_at | timestamp with time zone | CURRENT_TIMESTAMP | false |  |  | 更新日時 |

## Constraints

| Name | Type | Definition |
| ---- | ---- | ---------- |
| songs_original_songs_original_song_id_fkey | FOREIGN KEY | FOREIGN KEY (original_song_id) REFERENCES original_songs(id) |
| songs_original_songs_song_id_fkey | FOREIGN KEY | FOREIGN KEY (song_id) REFERENCES songs(id) |
| songs_original_songs_pkey | PRIMARY KEY | PRIMARY KEY (song_id, original_song_id) |

## Indexes

| Name | Definition |
| ---- | ---------- |
| songs_original_songs_pkey | CREATE UNIQUE INDEX songs_original_songs_pkey ON public.songs_original_songs USING btree (song_id, original_song_id) |

## Relations

![er](public.songs_original_songs.svg)

---

> Generated by [tbls](https://github.com/k1LoW/tbls)