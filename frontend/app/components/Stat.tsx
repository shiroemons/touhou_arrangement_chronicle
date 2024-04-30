interface StatProps {
  songCount: number;
  albumCount: number;
  artistCount: number;
  circleCount: number;
}

export default function Stat({
  songCount,
  albumCount,
  artistCount,
  circleCount,
}: StatProps) {
  return (
    <div className="stats stats-vertical lg:stats-horizontal shadow">
      <div className="stat">
        <div className="stat-title">登録楽曲数</div>
        <div className="stat-value">{songCount}</div>
      </div>

      <div className="stat">
        <div className="stat-title">登録アルバム数</div>
        <div className="stat-value">{albumCount}</div>
      </div>

      <div className="stat">
        <div className="stat-title">登録サークル数</div>
        <div className="stat-value">{circleCount}</div>
      </div>

      <div className="stat">
        <div className="stat-title">登録アーティスト数</div>
        <div className="stat-value">{artistCount}</div>
      </div>
    </div>
  );
}
