import type { LoaderFunctionArgs } from 'react-router';
import { useLoaderData } from 'react-router';
import { getSongs, type Song } from '../services/songs.server';

export async function loader({ request }: LoaderFunctionArgs) {
  const url = new URL(request.url);
  const limit = parseInt(url.searchParams.get('limit') || '20', 10);
  const page = parseInt(url.searchParams.get('page') || '1', 10);
  const offset = (page - 1) * limit;

  const songs = await getSongs(limit, offset);
  return { songs, page, limit };
}

export default function Songs() {
  const { songs, page, limit } = useLoaderData<typeof loader>();
  
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">曲一覧</h1>
      
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {songs.map((song: Song) => (
          <div 
            key={song.id} 
            className="border rounded-lg p-4 hover:shadow-md transition-shadow"
          >
            <h2 className="text-xl font-semibold">
              {song.displayName || song.name}
            </h2>
            
            <div className="mt-2 text-sm text-gray-600">
              {song.releaseYear && (
                <span>
                  {song.releaseYear}
                  {song.releaseMonth ? `/${song.releaseMonth}` : ''}
                </span>
              )}
            </div>
            
            <div className="mt-4 space-y-1">
              {song.artists.map((artist, index) => (
                <div key={index} className="text-sm">
                  <span className="font-medium">
                    {artist.roleDisplayName || artist.roleName}:
                  </span>{' '}
                  <span>
                    {artist.artistDisplayName || artist.artistName}
                  </span>
                </div>
              ))}
            </div>
            
            <div className="mt-4">
              <a 
                href={`/songs/${song.id}`}
                className="text-blue-600 hover:underline text-sm"
              >
                詳細を見る
              </a>
            </div>
          </div>
        ))}
      </div>

      {songs.length > 0 && (
        <div className="mt-8 flex justify-center">
          <nav className="flex items-center space-x-2">
            {page > 1 && (
              <a 
                href={`/songs?page=${page - 1}&limit=${limit}`}
                className="px-3 py-1 border rounded hover:bg-gray-100"
              >
                前へ
              </a>
            )}
            <span className="px-3 py-1">
              {page}ページ目
            </span>
            <a 
              href={`/songs?page=${page + 1}&limit=${limit}`}
              className="px-3 py-1 border rounded hover:bg-gray-100"
            >
              次へ
            </a>
          </nav>
        </div>
      )}
      
      {songs.length === 0 && (
        <div className="text-center py-10 text-gray-500">
          曲が見つかりませんでした
        </div>
      )}
    </div>
  );
} 