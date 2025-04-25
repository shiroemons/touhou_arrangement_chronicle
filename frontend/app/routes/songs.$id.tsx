import { useLoaderData, useParams } from 'react-router';
import { getSongById, type Song } from '../services/songs.server';

export async function loader({ params }: { params: { id: string } }) {
  const id = params.id;
  if (!id) {
    throw new Response("Not Found", { status: 404 });
  }

  const song = await getSongById(id);
  if (!song) {
    throw new Response("Not Found", { status: 404 });
  }

  return { song };
}

export default function SongDetail() {
  const { song } = useLoaderData<{ song: Song }>();
  const params = useParams();
  
  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex items-center mb-6">
        <a 
          href="/songs" 
          className="text-blue-600 hover:underline mr-4"
        >
          ← 曲一覧に戻る
        </a>
        <h1 className="text-3xl font-bold">
          {song.displayName || song.name}
        </h1>
      </div>
      
      <div className="bg-white shadow-md rounded-lg p-6 mb-6">
        <div className="mb-4">
          <h2 className="text-xl font-semibold mb-2">基本情報</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <div className="text-gray-600">曲名</div>
              <div className="font-medium">{song.displayName || song.name}</div>
            </div>
            
            {(song.releaseYear || song.releaseMonth) && (
              <div>
                <div className="text-gray-600">リリース</div>
                <div className="font-medium">
                  {song.releaseYear}
                  {song.releaseMonth ? `/${song.releaseMonth}` : ''}
                </div>
              </div>
            )}
          </div>
        </div>
        
        <div>
          <h2 className="text-xl font-semibold mb-2">アーティスト情報</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
            {song.artists.map((artist, index) => (
              <div key={index} className="flex">
                <div className="font-medium min-w-28">
                  {artist.roleDisplayName || artist.roleName}:
                </div>
                <div>
                  {artist.artistDisplayName || artist.artistName}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
} 