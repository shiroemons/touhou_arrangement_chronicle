import * as React from "react"
import { Link } from "react-router"
import { cn } from "~/lib/utils"

interface FooterProps extends React.HTMLAttributes<HTMLElement> {
  className?: string
}

export function Footer({ className, ...props }: FooterProps) {
  return (
    <footer
      className={cn("w-full border-t bg-background py-6 md:py-8", className)}
      {...props}
    >
      <div className="container mx-auto px-4">
        {/* モバイル表示 (シンプルな一列レイアウト) */}
        <div className="md:hidden space-y-6">
          <div className="text-center">
            <div className="flex justify-center space-x-3 mb-4">
              <Link to="/about" className="text-xs text-muted-foreground hover:text-foreground">
                このサイトについて
              </Link>
              <Link to="/terms" className="text-xs text-muted-foreground hover:text-foreground">
                利用規約
              </Link>
              <Link to="/privacy" className="text-xs text-muted-foreground hover:text-foreground">
                プライバシーポリシー
              </Link>
            </div>
            <p className="text-xs text-muted-foreground">
              &copy; {new Date().getFullYear()} 迷い家の白猫
            </p>
          </div>
        </div>

        {/* デスクトップ表示 (グリッドレイアウト) */}
        <div className="hidden md:grid grid-cols-3 gap-8 max-w-5xl mx-auto">
          <div className="space-y-3 text-left">
            <h3 className="text-sm font-medium">サイト情報</h3>
            <div className="flex flex-col space-y-2">
              <Link to="/about" className="text-sm text-muted-foreground hover:text-foreground">
                このサイトについて
              </Link>
              <Link to="/terms" className="text-sm text-muted-foreground hover:text-foreground">
                利用規約
              </Link>
              <Link to="/privacy" className="text-sm text-muted-foreground hover:text-foreground">
                プライバシーポリシー
              </Link>
            </div>
          </div>
          
          <div className="space-y-3 text-left">
            <h3 className="text-sm font-medium">カテゴリー</h3>
            <div className="flex flex-col space-y-2">
              <Link to="/original-songs" className="text-sm text-muted-foreground hover:text-foreground">
                原作・原曲別
              </Link>
              <Link to="/events" className="text-sm text-muted-foreground hover:text-foreground">
                イベント別
              </Link>
              <Link to="/circles" className="text-sm text-muted-foreground hover:text-foreground">
                サークル別
              </Link>
              <Link to="/artists" className="text-sm text-muted-foreground hover:text-foreground">
                アーティスト別
              </Link>
              <Link to="/statistics" className="text-sm text-muted-foreground hover:text-foreground">
                統計情報
              </Link>
            </div>
          </div>
          
          <div className="space-y-3 text-left">
            <h3 className="text-sm font-medium">関連サイト</h3>
            <div className="flex flex-col space-y-2">
              <a
                href="https://touhou-karaoke.com/"
                target="_blank"
                rel="noreferrer"
                className="text-sm text-muted-foreground hover:text-foreground"
              >
                東方カラオケ検索
              </a>
              <a
                href="https://music.touhou-search.com/"
                target="_blank"
                rel="noreferrer"
                className="text-sm text-muted-foreground hover:text-foreground"
              >
                東方同人音楽流通検索
              </a>
            </div>
          </div>
        
          <div className="col-span-3 mt-8 border-t pt-6 text-center">
            <p className="text-sm text-muted-foreground">
              &copy; {new Date().getFullYear()} 迷い家の白猫
            </p>
          </div>
        </div>
      </div>
    </footer>
  )
} 