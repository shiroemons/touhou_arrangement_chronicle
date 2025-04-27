import { Moon, Sun, Monitor } from "lucide-react";
import { useTheme, type Theme } from "../../lib/theme";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from "./dropdown-menu";
import { cn } from "../../lib/utils";
import { Button } from "./button";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  const options: { value: Theme; label: string; icon: React.ReactNode }[] = [
    {
      value: "light",
      label: "ライト",
      icon: <Sun className="size-4" />
    },
    {
      value: "dark",
      label: "ダーク",
      icon: <Moon className="size-4" />
    },
    {
      value: "system",
      label: "システム",
      icon: <Monitor className="size-4" />
    }
  ];

  // 現在選択されているテーマのアイコンを表示
  const currentIcon = options.find(option => option.value === theme)?.icon || options[2].icon;

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="size-9 rounded-md"
          aria-label="テーマ設定"
        >
          {currentIcon}
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        {options.map((option) => (
          <DropdownMenuItem
            key={option.value}
            onClick={() => setTheme(option.value)}
            className={cn(
              "flex items-center gap-2 cursor-pointer",
              theme === option.value && "bg-accent"
            )}
          >
            {option.icon}
            <span>{option.label}</span>
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
} 