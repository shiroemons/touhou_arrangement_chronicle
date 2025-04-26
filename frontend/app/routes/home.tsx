import type { Route } from "./+types/home";
import { Link } from "react-router";
import { 
  MusicIcon, 
  BookOpenIcon, 
  UsersIcon, 
  CalendarIcon, 
  SearchIcon, 
  ArrowRightIcon, 
  ChevronDownIcon, 
  BellIcon, 
  AlbumIcon, 
  Building2Icon, 
  SparklesIcon,
  Disc3Icon,
  TrendingUpIcon,
  StarIcon,
  HeadphonesIcon
} from "lucide-react";
import { Button } from "../components/ui/button";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "../components/ui/card";
import { Input } from "../components/ui/input";
import { Separator } from "../components/ui/separator";
import {
  HoverCard,
  HoverCardContent,
  HoverCardTrigger,
} from "../components/ui/hover-card";

export function meta({}: Route.MetaArgs) {
  return [
    { title: "東方編曲録　〜 Arrangement Chronicle - ホーム" },
    { name: "description", content: "東方Projectの音楽アレンジ情報を集めたデータベース" },
  ];
}

export default function Home() {
  // 仮のデータ: 実際のアプリケーションでは、APIから取得するなど適切に実装する
  const stats = {
    songsCount: 123456
  };

  return (
    <main className="min-h-screen bg-background text-foreground overflow-hidden">
      {/* ヒーローセクション */}
      <section className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden">
        {/* 背景エフェクト - より洗練された背景 */}
        <div className="absolute inset-0 bg-gradient-to-b from-background via-background/95 to-background/90 z-0">
          {/* メインの背景グラデーション */}
          <div className="absolute -top-20 -left-20 w-[40rem] h-[40rem] rounded-full bg-primary/10 blur-[10rem] opacity-50"></div>
          <div className="absolute top-1/2 -right-20 w-[35rem] h-[35rem] rounded-full bg-indigo-500/10 blur-[10rem] opacity-50"></div>
          <div className="absolute -bottom-20 left-1/3 w-[30rem] h-[30rem] rounded-full bg-blue-500/10 blur-[10rem] opacity-30"></div>
          
          {/* 背景に東方Projectっぽい要素を追加 */}
          <div className="absolute inset-0 bg-[url('/images/touhou-pattern.png')] bg-repeat opacity-5"></div>
          
          {/* 魔法陣のような円形パターン */}
          <div className="absolute top-[20%] right-[15%] w-64 h-64 border border-primary/20 rounded-full opacity-30 animate-[spin_60s_linear_infinite]"></div>
          <div className="absolute top-[20%] right-[15%] w-80 h-80 border border-primary/15 rounded-full opacity-20 animate-[spin_80s_linear_infinite_reverse]"></div>
          <div className="absolute top-[20%] right-[15%] w-96 h-96 border border-primary/10 rounded-full opacity-10 animate-[spin_100s_linear_infinite]"></div>
          
          {/* 左側に東方風の装飾的なシルエット */}
          <div className="absolute left-0 bottom-0 w-full h-full opacity-10 bg-[url('/images/touhou-silhouette.png')] bg-no-repeat bg-left-bottom bg-contain"></div>
        </div>
        
        {/* コンテンツコンテナ */}
        <div className="container px-4 md:px-6 z-10 max-w-7xl mx-auto">
          <div className="flex flex-col items-center text-center">
            {/* 東方風のロゴ装飾 */}
            <div className="relative mb-6">
              <div className="absolute -inset-1 bg-primary/20 blur-sm rounded-full opacity-75"></div>
              <h1 className="relative text-4xl md:text-6xl lg:text-8xl font-bold tracking-tight">
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-primary to-primary/80">東方編曲録</span>
              </h1>
            </div>
            
            <p className="text-xl md:text-2xl lg:text-3xl text-foreground/80 tracking-tight mb-8 font-light relative">
              <span className="relative inline-block">
                〜 <span className="relative inline-block">
                  Arrangement Chronicle
                  <span className="absolute -bottom-1 left-0 w-full h-px bg-gradient-to-r from-transparent via-primary/50 to-transparent"></span>
                </span> 〜
              </span>
            </p>
            
            {/* 登録アレンジ楽曲数のカウンター表示 - より魅力的に */}
            <div className="mb-10 flex flex-col items-center relative">
              <div className="absolute -inset-4 bg-primary/5 blur-md rounded-full"></div>
              <p className="text-base text-foreground/60 relative">現在の登録アレンジ楽曲数</p>
              <div className="flex items-baseline relative">
                <span className="text-4xl md:text-5xl lg:text-6xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-primary via-primary/90 to-indigo-500 tracking-tighter">
                  {stats.songsCount.toLocaleString()}
                </span>
                <span className="text-lg text-foreground/70 ml-2">曲</span>
              </div>
            </div>
            
            <p className="text-base md:text-lg text-foreground/60 max-w-xl mx-auto mb-12 relative">
              <span className="relative">
                ふとした検索が、運命の一曲に繋がるかも。
                <span className="absolute -bottom-2 left-1/4 right-1/4 h-px bg-gradient-to-r from-transparent via-foreground/20 to-transparent"></span>
              </span>
            </p>
            
            {/* 検索バー - よりスタイリッシュに */}
            <div className="w-full max-w-2xl mb-16 relative group">
              <div className="absolute -inset-0.5 bg-gradient-to-r from-primary/20 to-indigo-500/20 rounded-full opacity-75 group-hover:opacity-100 blur-sm transition duration-1000"></div>
              <div className="relative flex items-center">
                <Input 
                  type="text" 
                  placeholder="キーワード・タグ・原作・原曲・サークル・アーティスト・イベントから検索"
                  className="w-full py-6 px-5 pr-12 rounded-full border border-foreground/10 bg-background/80 backdrop-blur-sm text-base focus:outline-none focus-visible:ring-primary/50 focus-visible:border-primary transition-all shadow-sm h-auto"
                />
                <Button 
                  size="icon" 
                  variant="ghost" 
                  className="absolute right-3 text-primary hover:text-primary/80 transition-colors"
                >
                  <SearchIcon className="h-5 w-5" />
                  <span className="sr-only">検索</span>
                </Button>
              </div>
            </div>
            
            {/* 主要導線 - カテゴリーカード */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6 w-full max-w-4xl mb-20 relative">
              {/* 光の演出 */}
              <div className="absolute -inset-8 bg-primary/5 blur-lg rounded-3xl -z-10 opacity-50"></div>
              
              <HoverCard openDelay={200} closeDelay={100}>
                <HoverCardTrigger asChild>
                  <Card className="flex flex-col items-center justify-center p-4 rounded-xl border-foreground/5 hover:border-primary/20 group relative overflow-hidden transition-all duration-300 hover:shadow-md hover:shadow-primary/5 bg-background/60 backdrop-blur-sm">
                    <div className="absolute inset-0 bg-gradient-to-br from-primary/0 to-primary/0 opacity-0 group-hover:opacity-10 transition-opacity z-0"></div>
                    <div className="text-primary/80 group-hover:text-primary transition-colors mb-3 z-10">
                      <BookOpenIcon className="h-6 w-6" />
                    </div>
                    <CardTitle className="text-sm font-medium text-center z-10">原曲から探す</CardTitle>
                    <Link to="/original-songs" className="absolute inset-0" aria-label="原曲から探す"></Link>
                  </Card>
                </HoverCardTrigger>
                <HoverCardContent className="w-64 text-sm">
                  <div className="flex justify-between space-x-4">
                    <div className="space-y-1">
                      <h4 className="text-sm font-semibold">原曲から探す</h4>
                      <p className="text-xs text-muted-foreground">
                        ZUN氏による東方Projectの原曲情報をブラウズし、そのアレンジ作品を探索できます。
                      </p>
                    </div>
                  </div>
                </HoverCardContent>
              </HoverCard>

              <HoverCard openDelay={200} closeDelay={100}>
                <HoverCardTrigger asChild>
                  <Card className="flex flex-col items-center justify-center p-4 rounded-xl border-foreground/5 hover:border-primary/20 group relative overflow-hidden transition-all duration-300 hover:shadow-md hover:shadow-primary/5 bg-background/60 backdrop-blur-sm">
                    <div className="absolute inset-0 bg-gradient-to-br from-primary/0 to-primary/0 opacity-0 group-hover:opacity-10 transition-opacity z-0"></div>
                    <div className="text-primary/80 group-hover:text-primary transition-colors mb-3 z-10">
                      <CalendarIcon className="h-6 w-6" />
                    </div>
                    <CardTitle className="text-sm font-medium text-center z-10">イベントから探す</CardTitle>
                    <Link to="/events" className="absolute inset-0" aria-label="イベントから探す"></Link>
                  </Card>
                </HoverCardTrigger>
                <HoverCardContent className="w-64 text-sm">
                  <div className="flex justify-between space-x-4">
                    <div className="space-y-1">
                      <h4 className="text-sm font-semibold">イベントから探す</h4>
                      <p className="text-xs text-muted-foreground">
                        コミケや例大祭などの同人イベントで頒布された東方アレンジ作品を探せます。
                      </p>
                    </div>
                  </div>
                </HoverCardContent>
              </HoverCard>

              <HoverCard openDelay={200} closeDelay={100}>
                <HoverCardTrigger asChild>
                  <Card className="flex flex-col items-center justify-center p-4 rounded-xl border-foreground/5 hover:border-primary/20 group relative overflow-hidden transition-all duration-300 hover:shadow-md hover:shadow-primary/5 bg-background/60 backdrop-blur-sm">
                    <div className="absolute inset-0 bg-gradient-to-br from-primary/0 to-primary/0 opacity-0 group-hover:opacity-10 transition-opacity z-0"></div>
                    <div className="text-primary/80 group-hover:text-primary transition-colors mb-3 z-10">
                      <Building2Icon className="h-6 w-6" />
                    </div>
                    <CardTitle className="text-sm font-medium text-center z-10">サークルから探す</CardTitle>
                    <Link to="/circles" className="absolute inset-0" aria-label="サークルから探す"></Link>
                  </Card>
                </HoverCardTrigger>
                <HoverCardContent className="w-64 text-sm">
                  <div className="flex justify-between space-x-4">
                    <div className="space-y-1">
                      <h4 className="text-sm font-semibold">サークルから探す</h4>
                      <p className="text-xs text-muted-foreground">
                        東方アレンジ音楽を制作するサークルから作品を探索できます。
                      </p>
                    </div>
                  </div>
                </HoverCardContent>
              </HoverCard>

              <HoverCard openDelay={200} closeDelay={100}>
                <HoverCardTrigger asChild>
                  <Card className="flex flex-col items-center justify-center p-4 rounded-xl border-foreground/5 hover:border-primary/20 group relative overflow-hidden transition-all duration-300 hover:shadow-md hover:shadow-primary/5 bg-background/60 backdrop-blur-sm">
                    <div className="absolute inset-0 bg-gradient-to-br from-primary/0 to-primary/0 opacity-0 group-hover:opacity-10 transition-opacity z-0"></div>
                    <div className="text-primary/80 group-hover:text-primary transition-colors mb-3 z-10">
                      <UsersIcon className="h-6 w-6" />
                    </div>
                    <CardTitle className="text-sm font-medium text-center z-10">アーティストから探す</CardTitle>
                    <Link to="/artists" className="absolute inset-0" aria-label="アーティストから探す"></Link>
                  </Card>
                </HoverCardTrigger>
                <HoverCardContent className="w-64 text-sm">
                  <div className="flex justify-between space-x-4">
                    <div className="space-y-1">
                      <h4 className="text-sm font-semibold">アーティストから探す</h4>
                      <p className="text-xs text-muted-foreground">
                        作曲家、アレンジャー、ボーカリストなど、東方アレンジに関わるアーティストから作品を探せます。
                      </p>
                    </div>
                  </div>
                </HoverCardContent>
              </HoverCard>
            </div>
            
            {/* 下スクロールインジケーター - アニメーション改良 */}
            <div className="absolute bottom-12">
              <div className="flex flex-col items-center">
                <p className="text-xs text-foreground/60 mb-3 tracking-wider uppercase">詳しく見る</p>
                <div className="relative flex justify-center items-center">
                  <div className="absolute w-8 h-8 bg-foreground/5 rounded-full animate-ping"></div>
                  <ChevronDownIcon className="h-5 w-5 text-foreground/60 animate-bounce relative z-10" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 最新コンテンツセクション */}
      <section className="py-24 md:py-32 bg-gradient-to-b from-foreground/5 to-background relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-20 left-1/4 w-72 h-72 rounded-full bg-indigo-500/20 blur-[100px]"></div>
          <div className="absolute bottom-0 right-1/5 w-96 h-96 rounded-full bg-primary/30 blur-[120px]"></div>
        </div>
        <div className="container px-4 md:px-6 max-w-7xl mx-auto relative z-10">
          <h2 className="text-3xl md:text-4xl font-semibold mb-4 text-center">
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-primary to-primary/80">最新のコンテンツ</span>
          </h2>
          <p className="text-center text-foreground/60 text-sm md:text-base mb-16 max-w-2xl mx-auto">
            新しく追加されたアルバムや人気のある原曲など、最新の情報をチェックできます
          </p>
          
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-12">
            {/* お知らせ */}
            <Card className="backdrop-blur-sm bg-background/50 border-foreground/5 shadow-sm hover:shadow-md transition-shadow overflow-hidden">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center text-lg">
                  <BellIcon className="mr-3 h-5 w-5 text-primary" />
                  <span>お知らせ</span>
                </CardTitle>
              </CardHeader>
              <Separator className="mb-3" />
              <CardContent className="space-y-4 pb-6">
                <NewsItem 
                  title="サイトリニューアルのお知らせ" 
                  date="2024.05.15"
                  href="/news/renewal"
                />
                <NewsItem 
                  title="データベース更新情報" 
                  date="2024.05.10"
                  href="/news/db-update"
                />
                <NewsItem 
                  title="検索機能の強化について" 
                  date="2024.05.01"
                  href="/news/search-improvement"
                />
              </CardContent>
              <CardFooter>
                <Button variant="ghost" size="sm" asChild className="group">
                  <Link to="/news">
                    <span className="group-hover:mr-2 transition-all">すべてのお知らせを見る</span> 
                    <ArrowRightIcon className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
                  </Link>
                </Button>
              </CardFooter>
            </Card>
            
            {/* 最近追加されたアルバム */}
            <Card className="backdrop-blur-sm bg-background/50 border-foreground/5 shadow-sm hover:shadow-md transition-shadow overflow-hidden">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center text-lg">
                  <Disc3Icon className="mr-3 h-5 w-5 text-primary" />
                  <span>最近追加されたアルバム</span>
                </CardTitle>
              </CardHeader>
              <Separator className="mb-3" />
              <CardContent className="space-y-4 pb-6">
                <AlbumItem 
                  title="幻想交響曲 第43番" 
                  circle="交響アンサンブル幻想郷"
                  event="例大祭19"
                />
                <AlbumItem 
                  title="東方ジャズコレクション Vol.7" 
                  circle="Jazz東方研究会"
                  event="M3-2024春"
                />
                <AlbumItem 
                  title="エレクトロニック幻想郷" 
                  circle="電子幻想"
                  event="博麗神社例大祭"
                />
                <AlbumItem 
                  title="Piano Collections: 東方紅魔郷" 
                  circle="幻想ピアノ協奏曲"
                  event="コミケC102"
                />
              </CardContent>
              <CardFooter>
                <Button variant="ghost" size="sm" asChild className="group">
                  <Link to="/albums">
                    <span className="group-hover:mr-2 transition-all">すべてのアルバムを見る</span> 
                    <ArrowRightIcon className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
                  </Link>
                </Button>
              </CardFooter>
            </Card>
            
            {/* 人気の原曲 */}
            <Card className="backdrop-blur-sm bg-background/50 border-foreground/5 shadow-sm hover:shadow-md transition-shadow overflow-hidden">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center text-lg">
                  <TrendingUpIcon className="mr-3 h-5 w-5 text-primary" />
                  <span>人気の原曲</span>
                </CardTitle>
              </CardHeader>
              <Separator className="mb-3" />
              <CardContent className="space-y-4 pb-6">
                <PopularSongItem 
                  title="U.N.オーエンは彼女なのか?" 
                  product="東方紅魔郷"
                  count="312"
                  rank="1"
                />
                <PopularSongItem 
                  title="亡き王女の為のセプテット" 
                  product="東方紅魔郷"
                  count="286"
                  rank="2"
                />
                <PopularSongItem 
                  title="ネイティブフェイス" 
                  product="東方風神録"
                  count="243"
                  rank="3"
                />
                <PopularSongItem 
                  title="恋色マスタースパーク" 
                  product="東方永夜抄"
                  count="231"
                  rank="4"
                />
              </CardContent>
              <CardFooter>
                <Button variant="ghost" size="sm" asChild className="group">
                  <Link to="/original-songs/ranking">
                    <span className="group-hover:mr-2 transition-all">アレンジ原曲ランキングを見る</span> 
                    <ArrowRightIcon className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
                  </Link>
                </Button>
              </CardFooter>
            </Card>
          </div>
        </div>
      </section>

      {/* プロジェクト紹介セクション */}
      <section className="py-24 md:py-32 relative">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute -top-40 left-1/3 w-80 h-80 rounded-full bg-primary/20 blur-[100px]"></div>
        </div>
        <div className="container px-4 md:px-6 max-w-3xl mx-auto text-center relative z-10">
          <h2 className="text-3xl md:text-4xl font-semibold mb-8 bg-clip-text text-transparent bg-gradient-to-r from-primary to-primary/80">東方編曲録について</h2>
          <p className="text-foreground/70 mb-6 text-lg leading-relaxed">
            東方編曲録　〜 Arrangement Chronicle は、東方アレンジ楽曲を集めたデータベースサイトです。サークルやアーティストによる多彩なアレンジを、検索して手軽に探せる場所を目指しています。
          </p>
          <p className="text-foreground/70 mb-6 text-lg leading-relaxed">
            新たな楽曲との出会いを、そっと後押しできれば幸いです。
          </p>
          <p className="text-foreground/60 text-sm mb-10">
            当サイトは東方Projectの二次創作物であり、上海アリス幻樂団様とは一切関係ありません。
          </p>
          <Button variant="outline" size="lg" asChild>
            <Link to="/about" className="relative overflow-hidden group">
              <span className="absolute w-0 h-full bg-primary left-0 top-0 group-hover:w-full transition-all duration-300 ease-out"></span>
              <span className="relative group-hover:text-white transition-colors">詳しく知る</span>
            </Link>
          </Button>
        </div>
      </section>
    </main>
  );
}

// お知らせアイテム
function NewsItem({ title, date, href }: { 
  title: string; 
  date: string; 
  href: string 
}) {
  return (
    <div className="group">
      <Link to={href} className="block">
        <div className="flex flex-col py-3 border-b border-foreground/10 group-hover:border-foreground/20 transition-colors">
          <span className="text-xs text-foreground/50 mb-1">{date}</span>
          <h4 className="font-medium group-hover:text-primary transition-colors">{title}</h4>
        </div>
      </Link>
    </div>
  );
}

// 最近追加されたアルバムアイテム
function AlbumItem({ title, circle, event }: { 
  title: string; 
  circle: string; 
  event: string;
}) {
  return (
    <div className="group">
      <Link to={`/albums/${encodeURIComponent(title)}`} className="block">
        <div className="flex items-center py-3 border-b border-foreground/10 group-hover:border-foreground/20 transition-colors">
          <div className="w-10 h-10 rounded overflow-hidden mr-3 flex-shrink-0 bg-foreground/5 flex items-center justify-center">
            <AlbumIcon className="h-5 w-5 text-foreground/30" />
          </div>
          <div className="flex-1 min-w-0">
            <h4 className="font-medium group-hover:text-primary transition-colors truncate">{title}</h4>
            <p className="text-sm text-foreground/60 truncate">{circle}</p>
          </div>
          <div className="text-xs px-3 py-1 ml-2 bg-foreground/5 rounded-full text-foreground/70 group-hover:bg-primary/10 transition-colors flex-shrink-0">
            {event}
          </div>
        </div>
      </Link>
    </div>
  );
}

// 人気の原曲アイテム
function PopularSongItem({ title, product, count, rank }: { 
  title: string; 
  product: string; 
  count: string;
  rank: string;
}) {
  return (
    <div className="group">
      <Link to={`/original-songs/${encodeURIComponent(title)}`} className="block">
        <div className="flex items-center py-3 border-b border-foreground/10 group-hover:border-foreground/20 transition-colors">
          <div className="w-8 h-8 rounded-full bg-foreground/5 flex items-center justify-center mr-3 flex-shrink-0 text-foreground/70 group-hover:bg-primary/10 group-hover:text-primary/90 transition-colors font-medium">
            {rank}
          </div>
          <div className="flex-1 min-w-0">
            <h4 className="font-medium group-hover:text-primary transition-colors truncate">{title}</h4>
            <p className="text-sm text-foreground/60 truncate">{product}</p>
          </div>
          <div className="text-xs px-3 py-1 ml-2 bg-foreground/5 rounded-full text-foreground/70 group-hover:bg-primary/10 transition-colors flex-shrink-0">
            {count}曲
          </div>
        </div>
      </Link>
    </div>
  );
}
