import { Link, useLoaderData } from "react-router"
import { Sheet, SheetContent, SheetTrigger } from "../../components/ui/sheet"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "../../components/ui/dropdown-menu"
import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "../../components/ui/avatar"
import { Badge } from "../../components/ui/badge"
import { cn } from "../../lib/utils"
import { MenuIcon, LogIn, LogOut, User, ChevronDown, Settings, GitBranch, Bell } from "lucide-react"
import type { loader } from "../../root"
import type { User as UserType } from "../../types/auth"

interface Route {
  href: string
  label: string
}

const routes: Route[] = [
  {
    href: "/search",
    label: "検索",
  },
]

export function Header() {
  const { isAuthenticated, user } = useLoaderData<typeof loader>()
  
  return (
    <header className="sticky top-0 z-50 w-full border-b border-neutral-200 bg-white/75 backdrop-blur-lg dark:border-neutral-800 dark:bg-neutral-950/75">
      <div className="w-full max-w-[1400px] mx-auto px-4 sm:px-6 flex h-14 items-center">
        <div className="flex flex-1 items-center justify-between">
          <div className="flex items-center">
            <Link
              to="/"
              className="mr-6 flex items-center space-x-2 text-lg font-bold"
            >
              <span>東方編曲録</span>
            </Link>
            <nav className="hidden md:flex items-center gap-6 text-sm">
              {routes.map((route) => (
                <Link
                  key={route.href}
                  to={route.href}
                  className={cn(
                    "text-neutral-600 transition-colors hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-neutral-50"
                  )}
                >
                  {route.label}
                </Link>
              ))}
            </nav>
          </div>
          <div className="flex items-center gap-3">
            <NotificationBadge />
            {isAuthenticated ? (
              <UserNav user={user} />
            ) : (
              <Link
                to="/login"
                className="flex items-center gap-1 rounded-md px-3 py-2 text-sm font-medium text-neutral-600 transition-colors hover:bg-neutral-100 hover:text-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800 dark:hover:text-neutral-50"
              >
                <LogIn className="size-4" />
                <span>ログイン</span>
              </Link>
            )}
            <MobileNav isAuthenticated={isAuthenticated} />
          </div>
        </div>
      </div>
    </header>
  )
}

function MobileNav({ isAuthenticated }: { isAuthenticated: boolean }) {
  return (
    <div className="flex md:hidden">
      <Sheet>
        <SheetTrigger data-slot="trigger" asChild>
          <button
            className="size-10 inline-flex items-center justify-center rounded-md text-neutral-600 hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-neutral-50"
            aria-label="Toggle menu"
          >
            <MenuIcon className="size-5" />
          </button>
        </SheetTrigger>
        <SheetContent data-slot="content" side="left" className="pr-0">
          <Link
            to="/"
            className="mb-6 flex items-center space-x-2 text-lg font-semibold"
          >
            <span>東方編曲録</span>
          </Link>
          <nav className="flex flex-col gap-4 text-sm">
            {routes.map((route) => (
              <Link
                key={route.href}
                to={route.href}
                className={cn(
                  "text-neutral-600 transition-colors hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-neutral-50"
                )}
              >
                {route.label}
              </Link>
            ))}
            <div className="mt-4 border-t pt-4 dark:border-neutral-800">
              {isAuthenticated ? (
                <Link
                  to="/logout"
                  className="flex items-center gap-2 text-neutral-600 transition-colors hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-neutral-50"
                >
                  <LogOut className="size-4" />
                  <span>ログアウト</span>
                </Link>
              ) : (
                <Link
                  to="/login"
                  className="flex items-center gap-2 text-neutral-600 transition-colors hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-neutral-50"
                >
                  <LogIn className="size-4" />
                  <span>ログイン</span>
                </Link>
              )}
            </div>
          </nav>
        </SheetContent>
      </Sheet>
    </div>
  )
}

function UserNav({ user }: { user: UserType | null }) {
  // ユーザー名の頭文字を取得（アバターのフォールバック用）
  const getInitials = (name?: string) => {
    if (!name) return "U"
    return name.charAt(0).toUpperCase()
  }

  // 表示名を取得
  const displayName = user?.name || user?.nickname || user?.email || 'ユーザー'

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button 
          className="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-neutral-600 transition-colors hover:bg-neutral-100 hover:text-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800 dark:hover:text-neutral-50"
          aria-label="ユーザーメニュー"
        >
          <Avatar className="size-6">
            <AvatarImage src={user?.picture} alt={displayName} />
            <AvatarFallback>{getInitials(user?.name || user?.nickname)}</AvatarFallback>
          </Avatar>
          <span className="max-w-[100px] truncate">{displayName}</span>
          <ChevronDown className="size-3" />
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <div className="flex items-center gap-2 p-2">
          <Avatar className="size-8">
            <AvatarImage src={user?.picture} alt={displayName} />
            <AvatarFallback>{getInitials(user?.name || user?.nickname)}</AvatarFallback>
          </Avatar>
          <div className="flex flex-col space-y-0.5">
            <p className="text-sm font-medium">{displayName}</p>
            {user?.email && (
              <p className="text-xs text-neutral-500 dark:text-neutral-400 truncate max-w-[168px]">
                {user.email}
              </p>
            )}
          </div>
        </div>
        <DropdownMenuSeparator />
        <DropdownMenuItem asChild>
          <Link to="/profile" className="flex items-center gap-2 cursor-pointer">
            <User className="size-4" />
            <span>プロフィール</span>
          </Link>
        </DropdownMenuItem>
        <DropdownMenuItem asChild>
          <Link to="/settings" className="flex items-center gap-2 cursor-pointer">
            <Settings className="size-4" />
            <span>設定</span>
          </Link>
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem asChild>
          <Link to="/logout" className="flex items-center gap-2 text-red-600 dark:text-red-400 cursor-pointer">
            <LogOut className="size-4" />
            <span>ログアウト</span>
          </Link>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

// 通知バッジコンポーネント
function NotificationBadge() {
  // 通知があるかどうかのフラグ（実際のアプリでは状態管理から取得）
  const hasNotifications = true
  
  return (
    <button className="relative rounded-md p-1.5 text-neutral-600 transition-colors hover:bg-neutral-100 hover:text-neutral-900 dark:text-neutral-400 dark:hover:bg-neutral-800 dark:hover:text-neutral-50">
      <Bell className="size-5" />
      {hasNotifications && (
        <span className="absolute right-1 top-1 size-2 rounded-full bg-red-500" />
      )}
    </button>
  )
} 