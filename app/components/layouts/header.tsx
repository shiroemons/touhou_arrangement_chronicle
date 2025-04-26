import React from "react"
import { Link } from "react-router"
import { Sheet, SheetContent, SheetTrigger } from "../ui/sheet"
import { cn } from "../../lib/utils"
import { MenuIcon } from "lucide-react"

interface Route {
  href: string
  label: string
}

const routes: Route[] = [
  {
    href: "/",
    label: "ホーム",
  },
  {
    href: "/circles",
    label: "サークル",
  },
  {
    href: "/artists",
    label: "アーティスト",
  },
  {
    href: "/events",
    label: "イベント",
  },
  {
    href: "/albums",
    label: "アルバム",
  },
]

export function Header() {
  return (
    <header className="sticky top-0 z-50 w-full border-b border-neutral-200 bg-white/75 backdrop-blur-lg dark:border-neutral-800 dark:bg-neutral-950/75">
      <div className="container flex h-14 items-center">
        <MainNav />
        <MobileNav />
      </div>
    </header>
  )
}

function MainNav() {
  return (
    <div className="mr-4 hidden md:flex">
      <Link
        to="/"
        className="mr-6 flex items-center space-x-2 text-lg font-semibold"
      >
        <span>東方編曲録</span>
      </Link>
      <nav className="flex items-center gap-6 text-sm">
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
  )
}

function MobileNav() {
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
          </nav>
        </SheetContent>
      </Sheet>
    </div>
  )
} 