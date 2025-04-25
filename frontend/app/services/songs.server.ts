import { eq, desc, and, isNull } from 'drizzle-orm';
import { db } from './db.server';
import { songs, artists, artist_names, artist_roles, songs_artist_roles } from '../../drizzle/schema';

export interface Song {
  id: string;
  name: string;
  displayName?: string | null;
  releaseYear?: number | null;
  releaseMonth?: number | null;
  artists: {
    roleName: string;
    roleDisplayName?: string | null;
    artistName: string;
    artistDisplayName?: string | null;
  }[];
}

/**
 * 曲一覧を取得する
 * @param limit 取得件数
 * @param offset 取得開始位置
 * @returns 曲一覧
 */
export async function getSongs(limit = 20, offset = 0): Promise<Song[]> {
  const songResults = await db
    .select({
      id: songs.id,
      name: songs.name,
      displayName: songs.name,
      releaseYear: songs.release_year,
      releaseMonth: songs.release_month,
    })
    .from(songs)
    .where(
      and(
        isNull(songs.archived_at)
      )
    )
    .orderBy(desc(songs.release_date))
    .limit(limit)
    .offset(offset);

  // 曲ごとのアーティスト情報を取得
  const songsWithArtists = await Promise.all(
    songResults.map(async (song) => {
      const artistResults = await db
        .select({
          roleName: artist_roles.name,
          roleDisplayName: artist_roles.display_name,
          artistName: artist_names.name,
          artistDisplayName: artist_names.name_reading,
        })
        .from(songs_artist_roles)
        .innerJoin(artist_roles, eq(songs_artist_roles.artist_role_id, artist_roles.id))
        .innerJoin(artist_names, eq(songs_artist_roles.artist_name_id, artist_names.id))
        .innerJoin(artists, eq(artist_names.artist_id, artists.id))
        .where(eq(songs_artist_roles.song_id, song.id))
        .orderBy(songs_artist_roles.position);

      return {
        ...song,
        artists: artistResults,
      };
    })
  );

  return songsWithArtists;
}

/**
 * 曲の詳細情報を取得する
 * @param id 曲ID
 * @returns 曲の詳細情報
 */
export async function getSongById(id: string): Promise<Song | null> {
  const songResult = await db
    .select({
      id: songs.id,
      name: songs.name,
      displayName: songs.name,
      releaseYear: songs.release_year,
      releaseMonth: songs.release_month,
    })
    .from(songs)
    .where(
      and(
        eq(songs.id, id),
        isNull(songs.archived_at)
      )
    )
    .limit(1);

  if (songResult.length === 0) {
    return null;
  }

  const song = songResult[0];

  // 曲のアーティスト情報を取得
  const artistResults = await db
    .select({
      roleName: artist_roles.name,
      roleDisplayName: artist_roles.display_name,
      artistName: artist_names.name,
      artistDisplayName: artist_names.name_reading,
    })
    .from(songs_artist_roles)
    .innerJoin(artist_roles, eq(songs_artist_roles.artist_role_id, artist_roles.id))
    .innerJoin(artist_names, eq(songs_artist_roles.artist_name_id, artist_names.id))
    .innerJoin(artists, eq(artist_names.artist_id, artists.id))
    .where(eq(songs_artist_roles.song_id, song.id))
    .orderBy(songs_artist_roles.position);

  return {
    ...song,
    artists: artistResults,
  };
} 